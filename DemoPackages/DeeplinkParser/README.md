#  95. Парсим диплинки

Пакет для статьи № 95, [ссылка на статью](https://telegra.ph/95-Parsim-diplinki-11-29).

## DeeplinkParser

`DeeplinkParser` - это модель, преобразующая `URL` диплинка в один из заранее известных вариантов путей навигации в вашем приложении. Пример использования:

```swift
import DeeplinkParser

struct DemoContentView: View {
    @State private var navigationDestination: NavigationDestination?
    
    var body: some View {
        NavigationView {
            Text("Экран, обрабатывающий диплинк")
                .background(
                    NavigationLink(
                        destination: destinationView,
                        isActive: $navigationDestination.mappedToBool()
                    )
                )
        }
        .onOpenURL { url in
            guard let path = DeeplinkParser(url: url).path else { return }
            // Показываем нужный экран в зависимости от `path`
            switch path {
            case .simple:
                navigationDestination = .screen1
            case let .complex(id):
                navigationDestination = .screen2(id: id)
            }
        }
    }
    
    private enum NavigationDestination: Hashable {
        case screen1
        case screen2(String)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if let navigationDestination {
            switch navigationDestination {
            case .screen1: Text("Screen 1")
            case let .screen2(id): Text("Screen 2: \(id)")
            }
        }
    }
}

```

## DeeplinkParameters

`DeeplinkParameters` - это модель, создающая словарь с параметрами из `URL` диплинка.
Может пригодиться, если у вас уже есть свой механизм обработки простых диплинков без параметров, и дополнительно нужно добавить обработку параметров.
Например, ваш механизм обработки диплинков знает, что при получении ссылки с определенным хостом нужно открыть экран профиля пользователя.
Со временем к этому диплинку добавили параметр, чтобы можно было открыть профиль другого пользователя с указанным идентификатором.
С использованием `DeeplinkParameters` этот пример может выглядеть следующим образом:

```swift
final class ProfileRouter {
    func handleDeeplink(_ url: URL) {
        let parameters = DeeplinkParameters(for: url)
        if url.host == "profile" {
            if let otherUserId = parameters["id"] {
                // Открываем экран другого пользователя
                openProfileScreen(with: otherUserId)
            } else {
                // Открываем экран главного пользователя без параметра
                openMainProfileScreen()
            }
        } else {
            print("Неподдерживаемый диплинк")
        }
    }
}
```
