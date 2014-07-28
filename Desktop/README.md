### Настройка раскладки клавиатуры


```
nano /home/user_name/.config/lxpanel/Lubuntu/panels/panel
```
Приводим модуль XKB к следующему виду

```
Plugin {
    type = xkb
    Config {
        DisplayType=2
        PerWinLayout=0
        NoResetOpt=0
        KeepSysLayouts=0
        Model=pc105
        LayoutsList=us,ru
        VariantsList=,winkeys
        ToggleOpt=alt_shift_toggle
        FlagSize=6
    }
}

```
Чтобы использовать системные настройки устанавливаем параметр
```
KeepSysLayouts=1
```
