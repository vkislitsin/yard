// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

#Использовать v8runner
#Использовать gitrunner
#Использовать tempfiles
#Использовать fs
#Использовать 1commands

Перем МенеджерОбработкиДанных;  // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;            // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;       // Структура              - параметры обработки
Перем ГитРепозитарий;           // Объект                 - объект управления репозитарием GIT
Перем Лог;                      // Объект                 - объект записи лога приложения

Перем ВерсияПлатформы;          // Строка                 - маска версии платформы 1С (8.3, 8.3.6 и т.п.)
Перем ПутьККонфигурации;        // Строка                 - путь к файлу конфигурации (CF) для выгрузки
Перем РепозитарийГит;           // Строка                 - путь к репозитарию git
Перем ИмяВеткиГит;              // Строка                 - имя ветки git в которую будет выполняться выгрузка
Перем ИмяАвтора;                // Строка                 - имя автора коммита в git
Перем ПочтаАвтора;              // Строка                 - почта автора коммита в git
Перем ДатаКоммита;              // Строка                 - дата коммита в git в формате POSIX
Перем СообщениеКоммита;         // Строка                 - сообщение коммита в git
Перем База_СтрокаСоединения;    // Строка                 - строка соединения служебной базы 1С
Перем КонвертироватьВФорматЕДТ; // Булево                 - конвертацировать в формат 1С:Enterprise development tools
Перем СнятьСПоддержки;          // Булево                 - снять конфигурацию с поддержки
Перем ВерсияЕДТ;                // Строка                 - верcия среды 1С:Enterprise development tools для конвертации
Перем ПутьКЕДТ;                 // Строка                 - каталог к установленной ЕДТ, актуально для релизов равной или выше 2024.1. При явном указании значение параметра версии ЕДТ будет проигнорировано
Перем ОтносительныйПуть;        // Строка                 - относительный путь к исходникам внутри репозитория
                                //                          для выполнения выгрузки
Перем ПутьКСпискуОбъектов;      // Строка                 - путь к файлу, содержащему список объектов конфигурации для выгрузки в репозиторий

Перем НакопленныеДанные;        // Массив(Структура)      - результаты обработки данных

#Область ПрограммныйИнтерфейс

// Функция - признак возможности обработки, принимать входящие данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может принимать входящие данные для обработки;
//	         Ложь - обработка не принимает входящие данные;
//
Функция ПринимаетДанные() Экспорт
	
	Возврат Ложь;
	
КонецФункции // ПринимаетДанные()

// Функция - признак возможности обработки, возвращать обработанные данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может возвращать обработанные данные;
//	         Ложь - обработка не возвращает данные;
//
Функция ВозвращаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ВозвращаетДанные()

// Функция - возвращает список параметров обработки
// 
// Возвращаемое значение:
//	Структура                                - структура входящих параметров обработки
//      *Тип                    - Строка         - тип параметра
//      *Обязательный           - Булево         - Истина - параметр обязателен
//      *ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//      *Описание               - Строка         - описание параметра
//
Функция ОписаниеПараметров() Экспорт
	
	Параметры = Новый Структура();
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ВерсияПлатформы",
	                          "Строка",
	                          Ложь,
	                          "8.3",
	                          "маска версии платформы 1С (8.3, 8.3.6 и т.п.)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьККонфигурации",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к файлу конфигурации (CF) для выгрузки");

	ДобавитьОписаниеПараметра(Параметры,
	                          "РепозитарийГит",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к репозитарию git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяВеткиГит",
	                          "Строка",
	                          Ложь,
	                          "base1c",
	                          "имя ветки git в которую будет выполняться выгрузка");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяАвтора",
	                          "Строка",
	                          Ложь,
	                          "1c",
	                          "имя автора коммита в git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПочтаАвтора",
	                          "Строка",
	                          Ложь,
	                          "1c@1c.ru",
	                          "почта автора коммита в git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ДатаКоммита",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "дата коммита в git в формате POSIX");

	ДобавитьОписаниеПараметра(Параметры,
	                          "СообщениеКоммита",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "сообщение коммита в git");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "База_СтрокаСоединения",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "строка соединения служебной базы 1С для выполнения выгрузки");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "КонвертироватьВФорматЕДТ",
	                          "Булево",
	                          Ложь,
	                          Ложь,
	                          "конвертировать в формат 1С:Enterprise development tools");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ВерсияЕДТ",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "версия среды 1С:Enterprise development tools");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьКЕДТ",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "каталог к установленной ЕДТ, актуально для релизов равной или выше 2024.1. При явном указании значение параметра версии ЕДТ будет проигнорировано");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "СнятьСПоддержки",
	                          "Булево",
	                          Ложь,
	                          Ложь,
	                          "снять конфигурацию с поддержки");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ОтносительныйПуть",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "Относительный путь исходников внутри репозитория");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьКСпискуОбъектов",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "Путь к файлу, содержащему список объектов конфигурации для выгрузки в репозиторий");
	Возврат Параметры;
	
КонецФункции // ОписаниеПараметров()

// Функция - Возвращает обработку - менеджер
// 
// Возвращаемое значение:
//	ВнешняяОбработкаОбъект - обработка-менеджер
//
Функция МенеджерОбработкиДанных() Экспорт
	
	Возврат МенеджерОбработкиДанных;
	
КонецФункции // МенеджерОбработкиДанных()

// Процедура - Устанавливает обработку - менеджер
//
// Параметры:
//	НовыйМенеджерОбработкиДанных      - ВнешняяОбработкаОбъект - обработка-менеджер
//
Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных) Экспорт
	
	МенеджерОбработкиДанных = НовыйМенеджерОбработкиДанных;
	
КонецПроцедуры // УстановитьМенеджерОбработкиДанных()

// Функция - Возвращает идентификатор обработчика
// 
// Возвращаемое значение:
//	Строка - идентификатор обработчика
//
Функция Идентификатор() Экспорт
	
	Возврат Идентификатор;
	
КонецФункции // Идентификатор()

// Процедура - Устанавливает идентификатор обработчика
//
// Параметры:
//	НовыйИдентификатор      - Строка - новый идентификатор обработчика
//
Процедура УстановитьИдентификатор(Знач НовыйИдентификатор) Экспорт
	
	Идентификатор = НовыйИдентификатор;
	
КонецПроцедуры // УстановитьИдентификатор()

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки данных
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ВерсияПлатформы"          , ПараметрыОбработки, "8.3");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьККонфигурации"        , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("РепозитарийГит"           , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяВеткиГит"              , ПараметрыОбработки, "base1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяАвтора"                , ПараметрыОбработки, "1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПочтаАвтора"              , ПараметрыОбработки, "1c@1c.ru");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ДатаКоммита"              , ПараметрыОбработки,
	                                             Служебный.ДатаPOSIX(ТекущаяУниверсальнаяДата()));
	УстановитьПараметрОбработкиДанныхИзСтруктуры("СообщениеКоммита"         , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("База_СтрокаСоединения"    , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("КонвертироватьВФорматЕДТ" , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ВерсияЕДТ"                , ПараметрыОбработки, Неопределено);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьКЕДТ"                 , ПараметрыОбработки, "");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("СнятьСПоддержки"          , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ОтносительныйПуть"        , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьКСпискуОбъектов"      , ПараметрыОбработки, Неопределено);

КонецПроцедуры // УстановитьПараметрыОбработкиДанных()

// Функция - Возвращает значение параметра обработки данных
// 
// Параметры:
//	ИмяПараметра      - Строка           - имя получаемого параметра
//
// Возвращаемое значение:
//	Произвольный      - значение параметра
//
Функция ПараметрОбработкиДанных(Знач ИмяПараметра) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ПараметрыОбработки.Свойство(ИмяПараметра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыОбработки[ИмяПараметра];
	
КонецФункции // ПараметрОбработкиДанных()

// Процедура - Устанавливает значение параметра обработки
//
// Параметры:
//	ИмяПараметра      - Строка           - имя устанавливаемого параметра
//	Значение          - Произвольный     - новое значение параметра
//
Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		ПараметрыОбработки = Новый Структура();
	КонецЕсли;
	
	ПараметрыОбработки.Вставить(ИмяПараметра, Значение);

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	Если ВРег(ИмяПараметра) = "ПУТЬККОНФИГУРАЦИИ" Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьККонфигурации = ВремФайл.ПолноеИмя;
	ИначеЕсли ВРег(ИмяПараметра) = "РЕПОЗИТАРИЙГИТ" Тогда
		ВремФайл = Новый Файл(Значение);
		РепозитарийГит = ВремФайл.ПолноеИмя;
	Иначе
		Выполнить(СтрШаблон("%1 = Значение;", ИмяПараметра));
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	ВходящиеДанные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт

	Распаковщик.ОбеспечитьКаталог(РепозитарийГит);

	ГитРепозитарий.УстановитьРабочийКаталог(РепозитарийГит);

	СлужебныйКаталогГит = Новый Файл(ОбъединитьПути(РепозитарийГит, ".git"));
	
	НовыйРепозитарий = Ложь;
	Если НЕ СлужебныйКаталогГит.Существует() Тогда
		ГитРепозитарий.Инициализировать();
		НовыйРепозитарий = Истина;
	КонецЕсли;

	Если НЕ ВРег(СокрЛП(ГитРепозитарий.ПолучитьТекущуюВетку())) = ВРег(СокрЛП(ИмяВеткиГит)) Тогда
		Если Гит_ВеткаСуществует(ГитРепозитарий, ИмяВеткиГит) Тогда
			Лог.Информация("[%1]: Переход на ветку GIT ""%2"" в репозитарии ""%3""",
			               ТипЗнч(ЭтотОбъект),
			               ИмяВеткиГит,
			               ГитРепозитарий.ПолучитьРабочийКаталог());
			ГитРепозитарий.ПерейтиВВетку(ИмяВеткиГит, , Истина);
		ИначеЕсли НЕ НовыйРепозитарий Тогда
			Лог.Информация("[%1]: Создание ветки GIT ""%2"" в репозитарии ""%3""",
			               ТипЗнч(ЭтотОбъект),
			               ИмяВеткиГит,
			               ГитРепозитарий.ПолучитьРабочийКаталог());
			ГитРепозитарий.ПерейтиВВетку(ИмяВеткиГит, Истина);
		КонецЕсли;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ОтносительныйПуть) Тогда
		КаталогВыгрузки = ОбъединитьПути(РепозитарийГит, "src", "cf");
	Иначе
		КаталогВыгрузки = ОбъединитьПути(РепозитарийГит, ОтносительныйПуть);
	КонецЕсли;

	Если КонвертироватьВФорматЕДТ И Не ЗначениеЗаполнено(ВерсияЕДТ) И Не ЗначениеЗаполнено(ПутьКЕДТ) Тогда
		ВызватьИсключение "Требуется указать версию или путь к 1C:EDT в параметрах запуска";
	КонецЕсли;

	ВремФайл = Новый Файл(КаталогВыгрузки);
	НастройкиПроектаEDTСохранены = Ложь;
	Если ВремФайл.Существует() Тогда
		Если КонвертироватьВФорматЕДТ Тогда
			ВременныйКаталогСНастройками = "";
			НастройкиПроектаEDTСохранены = СохранитьСлужебныеДанныеЕДТ(КаталогВыгрузки, ВременныйКаталогСНастройками);
		КонецЕсли;

		ФайлОписания = Новый Файл(ОбъединитьПути(РепозитарийГит, "description.json"));
		ОписаниеВерсии = Новый Структура("Имя, Версия, Дата");
		Если ФайлОписания.Существует() Тогда
			ОписаниеВерсии = Служебный.ОписаниеРелиза(ФайлОписания.ПолноеИмя);
		КонецЕсли;
		
		Если НЕ НовыйРепозитарий Тогда
			Лог.Информация("[%1]: Начало удаления файлов версии %2 (%3) конфигурации ""%4"" из репозитария ""%5""",
			               ТипЗнч(ЭтотОбъект),
			               ОписаниеВерсии.Версия,
			               Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
			               ОписаниеВерсии.Имя,
			               КаталогВыгрузки);
			УдалитьФайлы(КаталогВыгрузки, "*");
		КонецЕсли;
	КонецЕсли;

	Распаковщик.ОбеспечитьКаталог(КаталогВыгрузки);

	ФайлКонфигурации = Новый Файл(ПутьККонфигурации);
	ФайлОписания = Новый Файл(ОбъединитьПути(ФайлКонфигурации.Путь, "description.json"));
	ОписаниеВерсии = Новый Структура("Имя, Версия, Дата");
	Если ФайлОписания.Существует() Тогда
		ОписаниеВерсии = Служебный.ОписаниеРелиза(ФайлОписания.ПолноеИмя);
	КонецЕсли;
	
	Лог.Информация("[%1]: Начало загрузки версии %2 (%3) конфигурации ""%4"" из файла ""%5""",
	               ТипЗнч(ЭтотОбъект),
	               ОписаниеВерсии.Версия,
	               Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
	               ОписаниеВерсии.Имя,
	               ПутьККонфигурации);

	Конфигуратор = Новый УправлениеКонфигуратором();
	Конфигуратор.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
	Конфигуратор.УстановитьКонтекст(База_СтрокаСоединения, "", "");

	Конфигуратор.ЗагрузитьКонфигурациюИзФайла(ПутьККонфигурации);

	МенеджерВР = Новый МенеджерВременныхФайлов();

	КаталогВыгрузкиИсходников = ?(КонвертироватьВФорматЕДТ, МенеджерВР.СоздатьКаталог("config-src"), КаталогВыгрузки);

	Лог.Информация("[%1]: Начало выгрузки в файлы версии %2 (%3) конфигурации ""%4"" %5 ""%6""",
	               ТипЗнч(ЭтотОбъект),
	               ОписаниеВерсии.Версия,
	               Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
	               ОписаниеВерсии.Имя,
	               ?(КонвертироватьВФорматЕДТ, "во временный каталог", "в репозитарий"),
	               КаталогВыгрузкиИсходников);
	
	Конфигуратор.ВыгрузитьКонфигурациюВФайлы(КаталогВыгрузкиИсходников,
                                      ,  // ФорматВыгрузки = ""
                                      ,  // ТолькоИзмененные = Ложь
                                      ,  // ПутьКФайлуВерсийДляСравнения = ""
                                      ПутьКСпискуОбъектов); // ПутьКСпискуОбъектовВыгрузки = ""

	Если ФайлОписания.Существует() Тогда
		НовыйФайлОписания = ОбъединитьПути(РепозитарийГит, "description.json");
		КопироватьФайл(ФайлОписания.ПолноеИмя, НовыйФайлОписания);
	КонецЕсли;

	ФайлДампа = Новый Файл(ОбъединитьПути(КаталогВыгрузкиИсходников, "ConfigDumpInfo.xml"));
	Если ФайлДампа.Существует() Тогда
		УдалитьФайлы(ФайлДампа.ПолноеИмя);
	КонецЕсли;

	Если КонвертироватьВФорматЕДТ Тогда
		СконвертироватьВФорматЕДТ(КаталогВыгрузкиИсходников, КаталогВыгрузки, ВерсияЕДТ);
		Если НастройкиПроектаEDTСохранены Тогда
			ВосстановитьСлужебныеДанныеЕДТ(КаталогВыгрузки, ВременныйКаталогСНастройками);
		КонецЕсли;
		Если СнятьСПоддержки Тогда
			ФайлПоддержки = Новый Файл(ОбъединитьПути(КаталогВыгрузки, "src", "Configuration", "ParentConfigurations.bin"));
			УдалитьФайлы(ФайлПоддержки.ПолноеИмя);

			ПутьККонфигурацииПоставщика = ОбъединитьПути(КаталогВыгрузки, "src", "Configuration", "ParentConfigurations");
			УдалитьФайлы(ПутьККонфигурацииПоставщика);
		КонецЕсли;
	КонецЕсли;

	Лог.Информация("[%1]: Начало добавления изменений в индекс Git", ТипЗнч(ЭтотОбъект));

	ГитРепозитарий.ДобавитьФайлВИндекс(".");
	
	Лог.Информация("[%1]: Начало помещения изменений в Git", ТипЗнч(ЭтотОбъект));

	ГитРепозитарий.УстановитьНастройку("user.name", ИмяАвтора);
	ГитРепозитарий.УстановитьНастройку("user.email", ПочтаАвтора);
	ПредставлениеАвтора = СтрШаблон("%1 <%2>", ИмяАвтора, ПочтаАвтора);
	ГитРепозитарий.Закоммитить(СообщениеКоммита, Истина, , ПредставлениеАвтора, ДатаКоммита, , ДатаКоммита);

	Лог.Информация("[%1]: Помещение изменений в Git завершено", ТипЗнч(ЭтотОбъект));

	Если НовыйРепозитарий Тогда
		Лог.Информация("[%1]: Создание ветки GIT ""%2"" в репозитарии ""%3""",
		               ТипЗнч(ЭтотОбъект),
		               ИмяВеткиГит,
		               ГитРепозитарий.ПолучитьРабочийКаталог());
		ГитРепозитарий.ПерейтиВВетку(ИмяВеткиГит, Истина);
	КонецЕсли;

	Лог.Информация("[%1]: Начало удаления временных файлов", ТипЗнч(ЭтотОбъект));
	МенеджерВР.Удалить();

	ПродолжениеОбработкиДанныхВызовМенеджера(КаталогВыгрузки);

	ЗавершениеОбработкиДанныхВызовМенеджера();

КонецПроцедуры // ОбработатьДанные()

Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Лог.Информация("[%1]: Завершение обработки данных.", ТипЗнч(ЭтотОбъект));

	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныйПрограммныйИнтерфейс

// Функция - возвращает объект управления логированием
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция Лог() Экспорт
	
	Возврат Лог;

КонецФункции // Лог()

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("v v8version", "", "маска версии платформы 1С (8.3, 8.3.6 и т.п.)")
	       .ТСтрока()
	       .ВОкружении("V8VERSION");

	Команда.Опция("cf cf-path", "", "путь к файлу конфигурации (CF) для выгрузки")
	       .ТСтрока()
	       .ВОкружении("YARD_CF_PATH");

	Команда.Опция("g git-path", "", "путь к репозитарию git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_PATH");

	Команда.Опция("b git-branch", "base1c", "имя ветки git в которую будет выполняться выгрузка")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_BRANCH");

	Команда.Опция("a git-author", "1c", "имя автора коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_AUTHOR");

	Команда.Опция("e git-author-email", "1c@1c.ru", "почта автора коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_AUTHOR_EMAIL");

	ДатаКоммита = Служебный.ДатаPOSIX(ТекущаяУниверсальнаяДата());
	Команда.Опция("d git-commit-date", ДатаКоммита, "дата коммита в git в формате POSIX (yyyy-MM-dd HH:mm:ss)")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_COMMIT_DATE");

	Команда.Опция("m git-commit-message", "", "сообщение коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_COMMIT_MESSAGE");
	
	Команда.Опция("C ibconnection", "", "строка подключения к служебной базе 1С для выполнения обновления")
	       .ТСтрока()
	       .ВОкружении("YARD_IB_CONNECTION");

	Команда.Опция("edt convert-to-edt", Ложь, "конвертировать в формат 1С:EDT")
	       .Флаг();

	Команда.Опция(
			"ev edt-version", "", 
			"верcия 1С:EDT для конвертации, при указании параметра пути к EDT значение игнорируется. 
			| Для версий ЕДТ от 2024.0 требуется указывать версию до 2 знаков (2024.2), ниже - до 3 знаков (2023.3.4)")
	       .ТСтрока()
	       .ВОкружении("YARD_EDT_VERSION");

	Команда.Опция("edtp edt-path", "", "путь к установленной EDT")
		   .ТСтрока()
		   .ВОкружении("YARD_EDT_PATH");
	
	Команда.Опция("rs remove-support", Ложь, "снять конфигруцию с поддержки")
	       .Флаг();
	
	Команда.Опция("srp src-relative-path", ОбъединитьПути("src", "cf"), "относительный путь исходников в репозитарии")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_SRC_PATH");

	Команда.Опция("olf object-list-file", "", "путь к файлу, содержащему список объектов конфигурации для выгрузки в репозиторий")
	       .ТСтрока()
	       .ВОкружении("YARD_OBJECT_LIST_FILE");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	УстановитьПараметрОбработкиДанных("ВерсияПлатформы"         , Команда.ЗначениеОпции("v8version"));
	УстановитьПараметрОбработкиДанных("ПутьККонфигурации"       , Команда.ЗначениеОпции("cf-path"));
	УстановитьПараметрОбработкиДанных("РепозитарийГит"          , Команда.ЗначениеОпции("git-path"));
	УстановитьПараметрОбработкиДанных("ИмяВеткиГит"             , Команда.ЗначениеОпции("git-branch"));
	УстановитьПараметрОбработкиДанных("ИмяАвтора"               , Команда.ЗначениеОпции("git-author"));
	УстановитьПараметрОбработкиДанных("ПочтаАвтора"             , Команда.ЗначениеОпции("git-author-email"));
	УстановитьПараметрОбработкиДанных("ДатаКоммита"             , Команда.ЗначениеОпции("git-commit-date"));
	УстановитьПараметрОбработкиДанных("СообщениеКоммита"        , Команда.ЗначениеОпции("git-commit-message"));
	УстановитьПараметрОбработкиДанных("База_СтрокаСоединения"   , Команда.ЗначениеОпции("ibconnection"));
	УстановитьПараметрОбработкиДанных("КонвертироватьВФорматЕДТ", Команда.ЗначениеОпции("convert-to-edt"));
	УстановитьПараметрОбработкиДанных("СнятьСПоддержки"         , Команда.ЗначениеОпции("remove-support"));
	УстановитьПараметрОбработкиДанных("ВерсияЕДТ"               , Команда.ЗначениеОпции("edt-version"));
	УстановитьПараметрОбработкиДанных("ПутьКЕДТ"                , Команда.ЗначениеОпции("edt-path"));
	УстановитьПараметрОбработкиДанных("ОтносительныйПуть"       , Команда.ЗначениеОпции("src-relative-path"));
	УстановитьПараметрОбработкиДанных("ПутьКСпискуОбъектов"     , Команда.ЗначениеОпции("object-list-file"));

	ОбработатьДанные();

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

// Процедура - выполняет действия обработки элемента данных
// и оповещает обработку-менеджер о продолжении обработки элемента
//
//	Параметры:
//		Элемент    - Произвольный     - Элемент данных для продолжения обработки
//
Процедура ПродолжениеОбработкиДанныхВызовМенеджера(Элемент)
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ПродолжениеОбработкиДанных(Элемент, Идентификатор);
	
КонецПроцедуры // ПродолжениеОбработкиДанныхВызовМенеджера()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанныхВызовМенеджера()
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ЗавершениеОбработкиДанных(Идентификатор);
	
КонецПроцедуры // ЗавершениеОбработкиДанныхВызовМенеджера()

#КонецОбласти // СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

#Область СлужебныеПроцедурыИФункции

// Процедура - добавляет описание параметра обработки
// 
// Параметры:
//     ОписаниеПараметров     - Структура      - структура описаний параметров
//     Параметр               - Строка         - имя параметра
//     Тип                    - Строка         - список возможных типов параметра
//     Обязательный           - Булево         - Истина - параметр обязателен
//     ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//     Описание               - Строка         - описание параметра
//
Процедура ДобавитьОписаниеПараметра(ОписаниеПараметров
	                              , Параметр
	                              , Тип
	                              , Обязательный = Ложь
	                              , ЗначениеПоУмолчанию = Неопределено
	                              , Описание = "")
	
	Если НЕ ТипЗнч(ОписаниеПараметров) = Тип("Структура") Тогда
		ОписаниеПараметров = Новый Структура();
	КонецЕсли;
	
	ОписаниеПараметра = Новый Структура();
	ОписаниеПараметра.Вставить("Тип"                , Тип);
	ОписаниеПараметра.Вставить("Обязательный"       , Обязательный);
	ОписаниеПараметра.Вставить("ЗначениеПоУмолчанию", ЗначениеПоУмолчанию);
	ОписаниеПараметра.Вставить("Описание"           , Описание);
	
	ОписаниеПараметров.Вставить(Параметр, ОписаниеПараметра);
	
КонецПроцедуры // ДобавитьОписаниеПараметра()

// Процедура - устанавливает значение переменной модуля с указанным именем
// из значения структуры с тем же именем или значение по умолчанию
// 
// Параметры:
//	ИмяПараметра          - Строка           - имя параметра для установки значения
//	СтруктураПараметров   - Структура        - структуры значений параметров
//	ЗначениеПоУмолчанию   - Произвольный     - значение переменной по умолчанию
//
Процедура УстановитьПараметрОбработкиДанныхИзСтруктуры(Знач ИмяПараметра,
	                                                  Знач СтруктураПараметров,
	                                                  Знач ЗначениеПоУмолчанию = "")

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	ЗначениеПараметра = ЗначениеПоУмолчанию;

	Если СтруктураПараметров.Свойство(ИмяПараметра) Тогда
		ЗначениеПараметра = СтруктураПараметров[ИмяПараметра];
	КонецЕсли;

	Выполнить(СтрШаблон("%1 = ЗначениеПараметра;", ИмяПараметра));

КонецПроцедуры // УстановитьПараметрОбработкиДанныхИзСтруктуры()

// Функция - проверяет наличие в текущем модуле переменной с указанным именем
// 
// Параметры:
//	ИмяПеременной      - Строка           - имя переменной для проверки
//
// Возвращаемое значение:
//	Булево      - Истина - переменная существует; Ложь - в противном случае.
//
Функция ЕстьПеременнаяМодуля(Знач ИмяПеременной)

	Попытка
		ЗначениеПеременной = Вычислить(ИмяПеременной);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;

КонецФункции // ЕстьПеременнаяМодуля()

// Процедура - Конвертирует исходники конфигурации из формата конфигуратора в формат ЕДТ
// 
// Параметры:
//	КаталогВФорматеКонфигуратора   - Строка   - каталог исходников конфигурации в формате конфигуратора
//	КаталогВФорматеЕДТ             - Строка   - каталог куда будут помещены конвертированные исходники
//                                              в формате 1С:Enterprise development tools
//	ВерсияЕДТ                      - Строка   - верия среды 1С:Enterprise development tools для конвертации
//
Процедура СконвертироватьВФорматЕДТ(КаталогВФорматеКонфигуратора, КаталогВФорматеЕДТ, ВерсияЕДТ = Неопределено)
	
	Лог.Информация("[%1]: Начало конвертации в формат ЕДТ", ТипЗнч(ЭтотОбъект));

	ИспользоватьНовуюВерсиюCLI = ЗначениеЗаполнено(ПутьКЕДТ) Или Версии.СравнитьВерсии("2023.3.5", ВерсияЕДТ) <= 0;

	Если ИспользоватьНовуюВерсиюCLI Тогда
		КонвертироватьВФорматЕДТ_НоваяВерсияCLI(КаталогВФорматеКонфигуратора, КаталогВФорматеЕДТ);
	Иначе
		КонвертироватьВФорматЕДТ_СтараяВерсияCLI(КаталогВФорматеКонфигуратора, КаталогВФорматеЕДТ, ВерсияЕДТ);
	КонецЕсли;
	
	Лог.Информация("[%1]: Завершена конвертация в формат ЕДТ", ТипЗнч(ЭтотОбъект));

КонецПроцедуры

Процедура КонвертироватьВФорматЕДТ_СтараяВерсияCLI(КаталогВФорматеКонфигуратора, КаталогВФорматеЕДТ, ВерсияЕДТ)
	ПараметрыЕНВ = Новый Соответствие();
	ПараметрыЕНВ.Вставить("RING_OPTS", "-Xmx6g -Dfile.encoding=UTF-8 -Dosgi.nl=ru -Duser.language=ru");
	МенеджерВР = Новый МенеджерВременныхФайлов();
	ВоркСпейсЕДТ = МенеджерВР.СоздатьКаталог("edt-ws");

	КомандаЕДТ = "edt";
	Если ЗначениеЗаполнено(ВерсияЕДТ) Тогда
		КомандаЕДТ = СтрШаблон("%1@%2", КомандаЕДТ, ВерсияЕДТ);
	КонецЕсли;
	ПараметрыЗапускаЕДТ = Новый Массив();
	ПараметрыЗапускаЕДТ.Добавить(КомандаЕДТ);
	ПараметрыЗапускаЕДТ.Добавить("workspace import");
	ПараметрыЗапускаЕДТ.Добавить("--configuration-files");
	ПараметрыЗапускаЕДТ.Добавить(КаталогВФорматеКонфигуратора);
	ПараметрыЗапускаЕДТ.Добавить("--project " + КаталогВФорматеЕДТ);
	ПараметрыЗапускаЕДТ.Добавить("--workspace-location");
	ПараметрыЗапускаЕДТ.Добавить(ВоркСпейсЕДТ);
	
	Команда = Новый Команда();
	Команда.УстановитьПеременныеСреды(ПараметрыЕНВ);
	Команда.УстановитьКоманду("ring");
	Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	Команда.ДобавитьПараметры(ПараметрыЗапускаЕДТ);
	
	КодВозврата = Команда.Исполнить();
	МенеджерВР.Удалить();
	Если КодВозврата <> 0 Тогда
		ВызватьИсключение Команда.ПолучитьВывод();
	КонецЕсли;

КонецПроцедуры

Процедура КонвертироватьВФорматЕДТ_НоваяВерсияCLI(КаталогВФорматеКонфигуратора, КаталогВФорматеЕДТ)
	МенеджерВР = Новый МенеджерВременныхФайлов();
	ВоркСпейсЕДТ = МенеджерВР.СоздатьКаталог("edt-ws");

	// Получаем путь к исполняемым файлам едт
	КаталогУстановкиЕДТ = ?(
		ЗначениеЗаполнено(ПутьКЕДТ), 
		ПутьКЕДТ,
		НайтиКаталогУстановкиЕДТ()
	);

	// Выполняем конвертацию
	ИмяФайлаСкрипта = ?(ПараметрыПриложения.ЭтоWindows(), "1cedtcli.exe", "1cedtcli");
	Команда = Новый Команда();
	ИтоговыйПуть = ОбъединитьПути(КаталогУстановкиЕДТ, ИмяФайлаСкрипта);
	Команда.УстановитьКоманду(ИтоговыйПуть);
	Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	
	ПараметрыЗапускаЕДТ = Новый Массив();
	ПараметрыЗапускаЕДТ.Добавить("-data");
	ПараметрыЗапускаЕДТ.Добавить(ВоркСпейсЕДТ);
	ПараметрыЗапускаЕДТ.Добавить("-timeout 3600");
	ПараметрыЗапускаЕДТ.Добавить("-vmargs");
	ПараметрыЗапускаЕДТ.Добавить("-Xmx8g -Dfile.encoding=UTF-8 -Dosgi.nl=ru -Duser.language=ru");
	ПараметрыЗапускаЕДТ.Добавить("-command");
	ПараметрыЗапускаЕДТ.Добавить("import");
	ПараметрыЗапускаЕДТ.Добавить("--configuration-files");
	ПараметрыЗапускаЕДТ.Добавить(КаталогВФорматеКонфигуратора);
	ПараметрыЗапускаЕДТ.Добавить("--project");
	ПараметрыЗапускаЕДТ.Добавить(КаталогВФорматеЕДТ);
	Команда.ДобавитьПараметры(ПараметрыЗапускаЕДТ);

	КодВозврата = Команда.Исполнить();
	МенеджерВР.Удалить();
	Если КодВозврата <> 0 Тогда
		ВызватьИсключение Команда.ПолучитьВывод();
	КонецЕсли;

КонецПроцедуры

Функция НайтиКаталогУстановкиЕДТ()
	КаталогиПоУмолчанию = КаталогиУстановкиЕДТПоУмолчанию();
	МаскаФайлаЗапуска = ?(ПараметрыПриложения.ЭтоWindows(), "**edtcli.exe", "**edtcli");
	
	Для каждого Каталог Из КаталогиПоУмолчанию Цикл
		Файл = Новый Файл(Каталог);
		Если Не Файл.существует() Тогда
			Продолжить;
		КонецЕсли;
		НайденныеКаталоги = НайтиФайлы(Каталог, СтрШаблон("*%1*", ВерсияЕДТ));
		Если ЗначениеЗаполнено(НайденныеКаталоги) Тогда
			ФайлыЗапуска = НайтиФайлы(НайденныеКаталоги[0].ПолноеИмя, МаскаФайлаЗапуска, Истина);
			Если ЗначениеЗаполнено(ФайлыЗапуска) Тогда
				Лог.Информация("[%1]: Найдена установленная версия ЕДТ: %2", ТипЗнч(ЭтотОбъект), ФайлыЗапуска[0].Путь);
				Возврат ФайлыЗапуска[0].Путь;		
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ВызватьИсключение "Не найден каталог установки EDT, укажите путь явно через параметры запуска";
КонецФункции

Функция КаталогиУстановкиЕДТПоУмолчанию()

	СистемнаяИнформация = Новый СистемнаяИнформация();
	Массив = Новый Массив();
	Если ПараметрыПриложения.ЭтоWindows() Тогда
		Массив.Добавить(ОбъединитьПути(СистемнаяИнформация.ПолучитьПутьПапки(СпециальнаяПапка.ЛокальныйКаталогДанныхПриложений), "1C\1cedtstart\installations"));
		Массив.Добавить("C:\Program Files\1C\1CE\components");
	Иначе
		Массив.Добавить("~/.local/share/1C/1cedtstart/installations");
		Массив.Добавить("/opt/1C/1CE/components");
	КонецЕсли;

	Возврат Массив;
	
КонецФункции


// Процедура - Проверяет существование указанной ветки в репозитарии GIT
// 
// Параметры:
//   ГитРепозитарий    - ГитРепозитарий    - объект управления репозитарием GIT
//   Ветка             - Строка            - имя ветки GIT
//
Функция Гит_ВеткаСуществует(ГитРепозитарий, Ветка)

	ТаблицаВеток = ГитРепозитарий.ПолучитьСписокВеток();
	Возврат ТаблицаВеток.НайтиСтроки(Новый Структура("Имя", Ветка)).Количество() > 0;

КонецФункции // Гит_ВеткаСуществует()

// Функция - Копирует служебные данные EDT во временный каталог
// 
// Параметры:
//   КаталогВыгрузки        - Строка    - исходный каталог проекта
//   КаталогСНастройками    - Строка    - (возвр.) временный каталог для хранения служебных данных
//
// Возвращаемое значение:
//   Булево    - Истина - служебные данные успешно скопированы
//
Функция СохранитьСлужебныеДанныеЕДТ(КаталогВыгрузки, КаталогСНастройками = "")

	МенеджерВР = Новый МенеджерВременныхФайлов();

	КаталогНастроекПроекта = ОбъединитьПути(КаталогВыгрузки, ".settings");

	ВремФайл = Новый Файл(КаталогНастроекПроекта);
	Если НЕ ВремФайл.Существует() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КаталогСНастройками = МенеджерВР.СоздатьКаталог("project-settings");
	ФС.КопироватьСодержимоеКаталога(КаталогНастроекПроекта, ОбъединитьПути(КаталогСНастройками, ".settings"));
	
	ФайлПроекта = ОбъединитьПути(КаталогВыгрузки, ".project");
	ВремФайл = Новый Файл(ФайлПроекта);
	Если НЕ ВремФайл.Существует() Тогда
		Возврат Ложь;
	КонецЕсли;

	КопироватьФайл(ФайлПроекта, ОбъединитьПути(КаталогСНастройками, ".project"));

	// В формате едт в каждом из метаданных могут находится файлы для подавления проверок валидации, их надо сохранить
	ФайлыПодавленияПроверок = НайтиФайлы(КаталогВыгрузки, "*.suppress", Истина);
	Для каждого ФайлПодавления Из ФайлыПодавленияПроверок Цикл
		ОтносительныйПутьФайла = ФС.ОтносительныйПуть(КаталогВыгрузки, ФайлПодавления.Путь);
		КаталогКСохранению = ОбъединитьПути(КаталогСНастройками, ОтносительныйПутьФайла);
		ФС.ОбеспечитьКаталог(КаталогКСохранению);
		НовыйПутьФайла = ОбъединитьПути(КаталогКСохранению, ФайлПодавления.Имя);
		КопироватьФайл(ФайлПодавления.ПолноеИмя, НовыйПутьФайла);
	КонецЦикла;
	
	Возврат Истина;

КонецФункции // СохранитьСлужебныеДанныеЕДТ()

// Функция - Восстанавливает служебные данные EDT во временный каталог
// 
// Параметры:
//   КаталогВыгрузки        - Строка    - исходный каталог проекта
//   КаталогСНастройками    - Строка    - временный каталог, содержащий служебне данные
//
Процедура ВосстановитьСлужебныеДанныеЕДТ(КаталогВыгрузки, КаталогСНастройками = "")

	ФС.КопироватьСодержимоеКаталога(КаталогСНастройками, КаталогВыгрузки);

КонецПроцедуры // ВосстановитьСлужебныеДанныеЕДТ()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  Менеджер	 - МенеджерОбработкиДанных    - менеджер обработки данных - владелец
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Менеджер = Неопределено)

	УстановитьМенеджерОбработкиДанных(Менеджер);

	Лог = ПараметрыПриложения.Лог();

	ГитРепозитарий = Новый ГитРепозиторий();

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
