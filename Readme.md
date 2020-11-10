- [SDOSFLEX](#sdosflex)
  - [Introducción](#introducción)
  - [Instalación](#instalación)
    - [Cocoapods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
      - [**En el "Project"**](#en-el-project)
      - [**En un Package.swift**](#en-un-packageswift)
  - [Cómo excluir la librería al subir a la App Store](#cómo-excluir-la-librería-al-subir-a-la-app-store)
    - [Cocoapods](#cocoapods-1)
  - [Swift Package Manager](#swift-package-manager-1)
    - [Usar FLEX en Objective-c](#usar-flex-en-objective-c)
    - [Usar FLEX en Swift](#usar-flex-en-swift)
  - [Cómo se usa](#cómo-se-usa)
  - [Referencias](#referencias)

# SDOSFLEX

- Enlace confluence: https://kc.sdos.es/x/HABm
- Changelog: https://github.com/SDOSLabs/SDOSFLEX/blob/master/CHANGELOG.md

## Introducción
SDOSFLEX es una librería que añade una invocación de la librería [FLEX](https://github.com/FLEXTool/FLEX) a través del gesto de agitar el dispositivo (⌘ + ⇧ + z en el simulador). Esta es una librería de debug, por lo que se recomienda que no esté incluida en las versiones de producción.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org).

Añadir el "source" privado de SDOSLabs al `Podfile`. Añadir también el source público de cocoapods para poder seguir instalando dependencias desde éste:
```ruby
source 'https://github.com/SDOSLabs/cocoapods-specs.git' #SDOSLabs source
source 'https://github.com/CocoaPods/Specs.git' #Cocoapods source
```

Añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSFLEX', '~> 1.3', :configurations => ['Debug']
pod 'FLEX', :configurations => ['Debug']
```

Como se observa, en la instalación de cocoapods se indica que la librería solo debe estar incluida en la configuración de `Debug`. Si fuera necesario incluir otras configuraciones de nuestro proyecto.

### Swift Package Manager

A partir de Xcode 12 podemos incluir esta librería a través de Swift package Manager. Existen 2 formas de añadirla a un proyecto:

#### **En el "Project"**

Debemos abrir nuestro proyecto en Xcode y seleccionar el proyecto para abrir su configuración. Una vez aquí seleccionar la pestaña "Swift Packages" y añadir el siguiente repositorio

```
https://github.com/SDOSLabs/SDOSFLEX.git
```

En el siguiente paso deberemos seleccionar la versión que queremos instalar. Recomentamos indicar "Up to Next Major" `1.3.0`.

Por último deberemos indicar el o los targets donde se deberá incluir la librería

#### **En un Package.swift**

Incluir la dependencia en el bloque `dependencies`:

``` swift
dependencies: [
    .package(url: "https://github.com/SDOSLabs/SDOSFLEX.git", .upToNextMajor(from: "1.3.0"))
]
```

Incluir la librería en el o los targets desados:

```js
.target(
    name: "YourDependency",
    dependencies: [
        "SDOSFLEX"
    ]
)
```

## Cómo excluir la librería al subir a la App Store

Como hemos indicado, esta librería es usada con fines de depuración, permitiendo consultar elementos internos de nuestra aplicación que normlamente no queremos que el público en general pueda ver. Por ello es importante que la librería no esté incluida en la versión de producción.

Para eliminarla debemos de tener en cuenta el método de instalación realizado.

### Cocoapods

Cocoapods proporciona el modificador `configurations` a la hora de definir la dependencia que se encarga de incluirla sólamente en aquellas configuraciones de nuestro proyecto que estén aquí indicadas, por lo que bastaría con no incluir en ningún caso la configuración usada para la subida a la App Store. Habría que indicarlo para las librerías `SDOSFLEX` y para `FLEX`

```ruby
pod 'SDOSFLEX', '~> 1.3', :configurations => ['Debug']
pod 'FLEX', :configurations => ['Debug']
```

Si necesitamos invocar algún método de la librería `FLEX` en nuestro proyecto debemos encapsular cualquier función de `FLEX` en una condición previa en tiempo de compilación, ya que habrá configuraciones que no tengan la librería y el uso del método provocaría un fallo en tiempo de compilación. En este caso podemos usar la condición `canImport(FLEX)`

```js
#if canImport(FLEX)
import FLEX
#endif

...

#if canImport(FLEX)
FLEXManager.shared.showExplorer()
#endif
```

## Swift Package Manager

En el caso de Swift Package Manager hay que hacer una exclusión manual, ya que por el momento no tiene ningún mecanismo de exclusión en base a las configuraciones del proyecto.

Deberemos ir al "Build Settings" de nuestro target y buscar la siguiente clave:

```
EXCLUDED_SOURCE_FILE_NAMES
```
Tendremos que indicar el valor `FLEX.o SDOSFLEX.o` a todas aquellas configuraciones que no queremos que la librería esté incluida. De esta forma, al compilar la aplicación, Xcode eliminará cualquier referencia a `FLEX` y `SDOSFLEX` que pueda contener nuestro binario. 

**Ojo, las librerías en si seguirán existiendo (por lo que se podrá hacer su import) pero estarán totalmente vacías sin incluir ninguna de sus clases.**

Si necesitamos invocar algún método de la librería `FLEX` en nuestro proyecto debemos encapsular cualquier función de `FLEX` en una condición previa en tiempo de compilación, ya que habrá configuraciones que no tengan la librería y el uso del método provocaría un fallo en tiempo de compilación.

Para ello, lo que tendremos que hacer es incluir unas variables que podamos usar en tiempo de compilación para saber si nuestra aplicación incluye o no la librería. Hay que configurar dos claves en el "Build Settings" **en las mismas configuraciones donde se han excluido la librería** (en la key `EXCLUDED_SOURCE_FILE_NAMES`).

### Usar FLEX en Objective-c

Para poder usar código de `FLEX` en Objective-c deberemos ir al "Build Settings" de nuestro target y buscar la siguiente clave:

```
GCC_PREPROCESSOR_DEFINITIONS
```

Tendremos que indicar el valor `SDOSFLEX_Disable=1` en la/s configuraciones correctas. De esta forma podemos usar código de `FLEX` de la siguiente forma:


```js
#if !SDOSFLEX_Disable
import FLEX
#endif

...

#if !SDOSFLEX_Disable
FLEXManager.shared.showExplorer()
#endif
```

### Usar FLEX en Swift

Para poder usar código de `FLEX` en Swift deberemos ir al "Build Settings" de nuestro target y buscar la siguiente clave:

```
SWIFT_ACTIVE_COMPILATION_CONDITIONS
```

Tendremos que indicar el valor `SDOSFLEX_Disable` en la/s configuraciones correctas. De esta forma podemos usar código de `FLEX` de la siguiente forma:

```js
#if !SDOSFLEX_Disable
@import FLEX;
#endif

...

#if !SDOSFLEX_Disable
[[FLEXManager sharedManager] showExplorer];
#endif
```


## Cómo se usa

La librería no necesita ninguna implementación más allá de que debe estar incluida en el binario de la app. Al estar incluida, la librería sobrescribe el evento "Shake gesture" del `window` principal de la app, haciendo que se invoque el método `FLEXManager.shared.showExplorer()` de FLEX.

## Referencias
* https://github.com/SDOSLabs/SDOSFLEX
* [FLEX](https://github.com/FLEXTool/FLEX) - ~> 4.2
