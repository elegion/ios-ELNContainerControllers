# ELNContainerControllers

Коллекция контейнер контроллеров

- `ELNContainerViewController`
- `ELNScrollViewController`

## Installation

###Cocoapods

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/elegion/ios-podspecs'

pod 'ELNConatinerControllers' 
```

###Carthage

```
github 'elegion/ios-ELNContainerControllers'
```

## Usage 

###ELNContainerViewController

Базовый класс на основе которого можно построить кастомный контейнер контроллер. Для этого во время наследования надо переопределить следющие методы:

```objective-c
- (void)willRemoveContentViewController {
    /// Called before removing content view controller  
}

- (void)willSetContentViewController {
    /// Called before new view controller will be inserted
}

- (void)insertContentViewControllerSubview {
    /// Subclasses must override to configure custom view hierarchy.
    /// Default implementation is adding a content view to the container view.
}
```

### ELNScrollViewController

Скрол контроллер выступает в качестве декоратора, который заворачивает любой контент в `UIScrollView`. Скрол вью настроен так, чтобы [корректно отрабатывать нажатия на `UIButton`](http://stackoverflow.com/questions/11507433/allow-uiscrollview-to-scroll-when-uibutton-is-pressed) и другие `UIControl`. Бывает полезен при создании форм логина/регистрации. 

```objective-c
MyCustomViewController *viewController = [MyCustomViewController new];
return [[ELNScrollViewController alloc] initWithContentViewController:viewController];
```

Вложенный вью контроллер имеет возможность конфигурировать родительский `ELNScrollViewController`, если он будет соответствовать протоколу `ELNScrollableViewController`:

```objective-c
@interface MyCustomViewController : UIViewController <ELNScrollableViewController>

@property (nonatomic, weak) ELNScrollViewController *scrollViewController;

@end
```

## Contribution

###Cocoapods

```sh
# download source code, fix bugs, implement new features

pod repo add legion https://github.com/elegion/ios-podspecs
pod repo push legion ELNContainerControllers.podspec
```
