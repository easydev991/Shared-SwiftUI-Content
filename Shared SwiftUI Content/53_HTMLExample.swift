import SwiftUI

struct HTMLTextViewExample: View {
    /// Используется только в iOS 14
    @State private var textViewHeight: CGFloat?
    private let text: String?
    private let maxLayoutWidth: CGFloat
    private var configuration = { (view: UITextView) in }
    
    /// - Parameters:
    ///   - text: Текст для отображения, может включать HTML-теги и спец.символы
    ///   - maxLayoutWidth: Максимальная ширина вьюхи для iOS 15+. В iOS 14 используется `GeometryReader` и этот параметр игнорируется
    ///   - configuration: Замыкание для настройки `UITextView` (любые параметры внешнего вида: цвет, шрифт, и т.д.)
    init(
        text: String,
        maxLayoutWidth: CGFloat,
        configuration: @escaping (UITextView) -> () = { _ in }
    ) {
        self.text = text
        self.maxLayoutWidth = maxLayoutWidth
        self.configuration = configuration
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            HTMLUITextViewRepresentable(
                textViewHeight: .constant(0), // В iOS 15 не используется
                maxLayoutWidth: maxLayoutWidth,
                text: text,
                configuration: configuration
            )
        } else {
            GeometryReader { geo in
                HTMLUITextViewRepresentable(
                    textViewHeight: $textViewHeight,
                    maxLayoutWidth: geo.maxWidth,
                    text: text,
                    configuration: configuration
                )
            }
            .frame(height: textViewHeight)
        }
    }
}

private extension GeometryProxy {
    /// Максимальная ширина вьюхи за вычетом безопасной зоны по бокам
    var maxWidth: CGFloat {
        size.width - safeAreaInsets.leading - safeAreaInsets.trailing
    }
}

private struct HTMLUITextViewRepresentable: UIViewRepresentable {
    @Binding private var textViewHeight: CGFloat?
    private let maxLayoutWidth: CGFloat
    private let text: String?
    private var configuration = { (view: UITextView) in }
    
    /// - Parameters:
    ///   - textViewHeight: Высота вьюхи, нужна только для iOS 14
    ///   - maxLayoutWidth: Максимальная ширина вьюхи для iOS 15+. В iOS 14 используется `GeometryReader` и этот параметр игнорируется
    ///   - text: Текст для отображения, может включать HTML-теги и спец.символы
    ///   - configuration: Замыкание для настройки `UITextView` (любые параметры внешнего вида: цвет, шрифт, и т.д.)
    init(
        textViewHeight: Binding<CGFloat?>,
        maxLayoutWidth: CGFloat,
        text: String?,
        configuration: @escaping (UITextView) -> () = { _ in }
    ) {
        self._textViewHeight = textViewHeight
        self.maxLayoutWidth = maxLayoutWidth
        self.text = text
        self.configuration = configuration
    }
    
    func makeUIView(context: Context) -> HTMLUITextView {
        let textView = HTMLUITextView()
        textView.htmlText = text
        if #available(iOS 15.0, *) {
            textView.maxLayoutWidth = maxLayoutWidth
        }
        return textView
    }
    
    func updateUIView(_ uiView: HTMLUITextView, context: Context) {
        guard text != uiView.htmlText else { return }
        // Если делать обновление без Task, то верстка может поехать
        Task { @MainActor in
            configuration(uiView)
            uiView.htmlText = text
            if #unavailable(iOS 15) { // Только для iOS < 15
                uiView.maxLayoutWidth = maxLayoutWidth
                textViewHeight = uiView.intrinsicContentSize.height
            }
        }
    }
}

private final class HTMLUITextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // Тут можно настроить основные параметры внешнего вида вьюхи
        // Часть параметров настроим тут, а часть - позже в превью
        isEditable = false
        dataDetectorTypes = .all
        textContainerInset = .zero
        contentInset = .zero
        self.textContainer.lineFragmentPadding = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Максимальная ширина вьюхи, которая нам подходит
    var maxLayoutWidth: CGFloat = 0 {
        didSet {
            guard maxLayoutWidth != oldValue else { return }
            // Если новое значение отличается от старого, сбрасываем intrinsicContentSize
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        maxLayoutWidth > 0
        ? sizeThatFits(.init(width: maxLayoutWidth, height: .greatestFiniteMagnitude))
        : super.intrinsicContentSize
    }
}

extension String {
    /// Превращает строку в `NSAttributedString` с параметрами html-документа
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            )
            return attributedString
        } catch {
            return NSAttributedString()
        }
    }
    
    /// Настраивает шрифт и цвет текста для строки, возвращает `NSAttributedString`
    func customHTMLAttributedString(font: UIFont?, textColor: UIColor) -> NSAttributedString? {
        guard let font else { return htmlToAttributedString }
        let hexCode = textColor.hexCodeString
        let css = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(hexCode);}</style>"
        let modifiedString = css + self
        return modifiedString.htmlToAttributedString
    }
}

extension UITextView {
    /// Свойство для удобства применения операций из предыдущего экстеншена
    var htmlText: String? {
        set {
            guard let newValue else { return }
            attributedText = newValue.customHTMLAttributedString(
                font: font,
                textColor: textColor ?? .label
            )
        }
        get { attributedText.string }
    }
}

extension UIColor {
    /// Делает строку с хекс-кодом для цвета
    var hexCodeString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

#Preview {
    let textWithHTML = """
<h1>Привет!</h1><p><b>Меня зовут Олег, я руковожу дизайн-направлением Samokat.tech</b><em>.</em> За последние пару лет наша команда выросла в 10 раз и стала одним из крупнейших департаментов компании.&nbsp;</p><p><u><b>Подобные темпы масштабирования неизбежно приводят к потребности быстро и сильно меняться: оптимизировать процессы, пересматривать методики и принципы управления. Необходимо постоянно наращивать скорость работы, не теряя в качестве, и пересобирать структуру, сохраняя лояльность команды. В этой статье я поделюсь тем, как мы решали эти задачи.&nbsp;</b></u></p><ul><li>Надеюсь, мой рассказ будет полезен дизайнерам и руководителям,</li><li><a href=\"https://habr.com\"><b>которые находятся на пороге или в процессе больших перемен.</b></a></li><li>Они смогут сравнить наш опыт со своим и найти для себя пару-тройку инсайтов.&nbsp;</li></ul><h2><a href=\"https://habr.com/ru/companies/samokat_tech/articles/788972/\"><em>О каком дизайне идёт речь</em></a></h2><p>Дизайн в<u><em> ИТ нередко выполняет сервисные функции</em></u>. Он по сути обслуживает бизнес как повар в ресторане,&nbsp;производя на заказ «блюда» из стандартного меню: интерфейсы, брендинг, маркетинговые материалы. Часто в структурах компаний нет отдельного дизайн-департамента, а специалисты являются частью продуктовых или коммуникационных команд.&nbsp;</p><p><u>Наш подход — другой. Для нас дизайнер — это скорее инженер, изобретатель. Человек, способный системно мыслить и </u><a href=\"https://habr.com\">преобразовывать мир вокруг себя, создавая что-то новое из ничего.</a></p><h3>На практике это</h3><ul><li>означает что мы не ограничиваем себя в том, чтобы искать решения для задач в самых разных областях методами дизайна. Чем быстрее растёт бизнес — тем выше число таких задач, тем больше направлений для нашей работы. <a href=\"https://habr.com\"><u>Именно так появляются новые практики.</u></a></li></ul>
"""
    return ScrollView {
        HTMLTextViewExample(
            text: textWithHTML,
            maxLayoutWidth: UIScreen.main.bounds.width - 40, // <- вычитаем по 20 с каждой стороны
            configuration: { uiView in
                // Настраиваем параметры UITextView
                uiView.textColor = .purple
                uiView.isScrollEnabled = false
                uiView.linkTextAttributes = [.foregroundColor: UIColor.systemGreen]
                uiView.font = .systemFont(ofSize: 20)
            }
        )
        .padding(.horizontal, 20)
    }
}
