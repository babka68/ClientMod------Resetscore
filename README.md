# ClientMod------Resetscore
Поддерживаемые игры: Source v34 and ClientMod

Описание: 
- CSS: Обнуление => убийств => смертей

Команды: 
- !rs, !кы, !resetscore, !куыуесщку.

Cvar:
- sm_enable 					"1" 					// 1 - Включить, 0 - Отключить плагин. (по умолчанию: 1)
- sm_join_info_chat 			"1" 					// Отвечает за вывод сообщения о доступных командах, после успешного подключения на сервер (по умолчанию: 1)
- sm_join_info_time				"15"					// Отвечает за время вывода сообщения о доступных командах(по умолчанию: 15)
- sm_show_silent_info_reset 	"1"						// Отвечает за вывод сообщения о сброшенном счёте игрока (по умолчанию: 1)

- Установка:
1) Поместить resetscore.smx по пути /addons/sourcemod/plugins
2) (Не обязательно) Поместить resetscore.sp по пути /addons/sourcemod/scripting
3) Поместить resetscore_cssold.phrases.txt по пути /addons/sourcemod/translations/clientmod
4) Перезапустить сервер
4) Настроить файла конфигурации cfg/sourcemod/clientmod/resetscore.cfg
5) Перезапустить сервер и наслаждаться работой плагина

Обновление 1.0
- Релиз под ClientMod

Обновление 1.1
- Мини оптимиззация:
- Заменена функция AddCommandListener на форвард OnClientSayCommand (так то лучше)
- Исправлена проблема, когда sm_enable "0" и вы пытаетесь написать любую фразу( Привет) или символ, а вам спамит "Плагин отключен!"

- Контакты для связи при возникновении проблемы/предложений: 
1. Discord babka68#4072
2. Telegram https://t.me/babka68
3. Вконтакте https://vk.com/id142504197
4. WhatsApp: +7 (953) 124-71-33
