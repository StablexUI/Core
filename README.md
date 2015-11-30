StablexUI
======================

TBD


StablexUI Core
=======================
This library provides backend-independent part of StablexUI.


Installation
-----------------------
```
haxelib git https://github.com/StablexUI/Core stablexui-core
```
Normally you don't need to explicitly include this library in your project, because it will be automatically included by
StablexUI backend you choose.


Getting started
-----------------------
Install StablexUI Core and a backend (e.g. [StablexUI Flash](https://github.com/StablexUI/Flash)), then plug backend library into your project.
You can also install a theme (e.g. [FlatUI Theme](https://github.com/StablexUI/Theme-FlatUI)). If you use a theme, you need to instantiate it before initializing StablexUI.
Here is an initialization code required to get started:
```Haxe
import sx.Sx;
import sx.flatui.FlatUITheme;

class Main
{
    /**
     * Entry point to an app
     */
    static public function main ()
    {
        Sx.theme = new FlatUITheme();
        Sx.init(run);
    }


    /**
     * Entry point to your own code
     */
    static public function run ()
    {
        //Now you can create some widgets
        var button = new Button();
        button.text = 'Hello, world!';

        //add to `global` GUI root
        Sx.root.addChild(button);
    }
}
```