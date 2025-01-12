// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

Перем МенеджерОбработкиДанных;  // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;            // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;       // Структура              - параметры обработки
Перем Лог;                      // Объект                 - объект записи лога приложения

Перем ВерсияПлатформы;           // Строка                 - маска версии платформы 1С (8.3, 8.3.6 и т.п.)
Перем ПутьККаталогуКонфигураций; // Строка                 - путь к каталогу содержащему версии конфигурации
                                 //                          для выгрузки в git
Перем ИмяФайлаКонфигурации;      // Строка                 - имя файла конфигурации, по умолчанию "1Cv8.cf"
Перем РепозитарийГит;            // Строка                 - путь к репозитарию git
Перем ИмяВеткиГит;               // Строка                 - имя ветки git в которую будет выполняться выгрузка
Перем ИмяАвтора;                 // Строка                 - имя автора коммита в git
Перем ПочтаАвтора;               // Строка                 - почта автора коммита в git
Перем КонвертироватьВФорматЕДТ;  // Булево                 - конвертацировать в формат ЕДТ
Перем ВерсияЕДТ;                 // Строка                 - версия среды 1С:Enterprise development tools для конвертации
Перем ПутьКЕДТ;                  // Строка                 - каталог к установленной ЕДТ, актуально для релизов равной или выше 2024.1. При явном указании значение параметра версии ЕДТ будет проигнорировано
Перем СнятьСПоддержки;           // Булево                 - снять конфигурацию с поддержки
Перем ОтносительныйПуть;         // Строка                 - относительный путь к исходникам внутри репозитория
Перем База_СтрокаСоединения;     // Строка                 - строка соединения служебной базы 1С
                                 //                          для выполнения выгрузки
Перем ПутьКСпискуОбъектов;       // Строка                 - путь к файлу, содержащему список объектов конфигурации для выгрузки в репозиторий

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
	                          "ПутьККаталогуКонфигураций",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к каталогу содержащему версии конфигурации
	                          |для выгрузки в git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяФайлаКонфигурации",
	                          "Строка",
	                          Истина,
	                          "1Cv8.cf",
	                          "имя файла конфигурации, по умолчанию ""1Cv8.cf""");

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
	                          "КонвертироватьВФорматЕДТ",
	                          "Булево",
	                          Ложь,
	                          Ложь,
	                          "Конвертировать в формат ЕДТ");	
	
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
	                          "Снять конфигурацию с поддержки");	
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ОтносительныйПуть",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "Относительный путь исходников внутри репозитория");

	ДобавитьОписаниеПараметра(Параметры,
	                          "База_СтрокаСоединения",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "строка соединения служебной базы 1С для выполнения выгрузки");

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
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьККаталогуКонфигураций", ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяФайлаКонфигурации"     , ПараметрыОбработки, "1Cv8.cf");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("РепозитарийГит"           , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяВеткиГит"              , ПараметрыОбработки, "base1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяАвтора"                , ПараметрыОбработки, "1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПочтаАвтора"              , ПараметрыОбработки, "1c@1c.ru");
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

	Если ВРег(ИмяПараметра) = "ПУТЬККАТАЛОГУКОНФИГУРАЦИЙ" Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьККаталогуКонфигураций = ВремФайл.ПолноеИмя;
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

	ФайлыОписанийВерсий = НайтиФайлы(ПутьККаталогуКонфигураций, "description.json", Истина);

	Если ФайлыОписанийВерсий.Количество() = 0 Тогда
		Лог.Предупреждение("[%1]: Не найдены файлы описания версий ""description.json"" в каталоге %2,
		                   |возможно каталог указан некорректно.",
		                   ЭтотОбъект,
		                   ПутьККаталогуКонфигураций);
		Возврат;
	КонецЕсли;

	Лог.Информация("[%1]: Начало выгрузки в GIT каталога конфигураций %2.",
	               ЭтотОбъект,
	               ПутьККаталогуКонфигураций);
	
	ВерсииДляОбработки = Новый Массив();

	Для Каждого ТекФайл Из ФайлыОписанийВерсий Цикл
		ОписаниеВерсии = Служебный.ОписаниеРелиза(ТекФайл.ПолноеИмя);

		ФайлКонфигурации = Новый Файл(ОбъединитьПути(ТекФайл.Путь, ИмяФайлаКонфигурации));
		Если НЕ ФайлКонфигурации.Существует() Тогда
			Продолжить;
		КонецЕсли;

		ОписаниеВерсии.Вставить("КаталогВерсии", ТекФайл.Путь);

		ВерсииДляОбработки.Добавить(ОписаниеВерсии);
	КонецЦикла;

	Если ВерсииДляОбработки.Количество() = 0 Тогда
		Лог.Ошибка("[%1]: Не найден файл исходной конфигурации %2 и description.json в подкаталоге релиза в %3.",
			ЭтотОбъект,
			ИмяФайлаКонфигурации,
			ПутьККаталогуКонфигураций);
		Возврат;
	КонецЕсли;
	
	Служебный.СортироватьОписанияВерсийПоДате(ВерсииДляОбработки);

	ФайлОписанияПоследнейВерсии = Новый Файл(ОбъединитьПути(РепозитарийГит, "description.json"));

	ПоследняяВерсии     = "0.0.0.0";
	ДатаПоследнейВерсии = ВерсииДляОбработки[0].Дата - 1;

	Если ФайлОписанияПоследнейВерсии.Существует() Тогда

		ОписаниеВерсииВГит = Служебный.ОписаниеРелиза(ФайлОписанияПоследнейВерсии.ПолноеИмя);

		ПоследняяВерсии     = ОписаниеВерсииВГит.Версия;
		ДатаПоследнейВерсии = ОписаниеВерсииВГит.Дата;

	КонецЕсли;

	Для Каждого ТекОписание Из ВерсииДляОбработки Цикл

		Если ТекОписание.Дата <= ДатаПоследнейВерсии Тогда
			Лог.Отладка("[%1]: Дата версии %2 (%3) конфигурации %4 меньше или равна дате последней версии %5",
			            ЭтотОбъект,
			            Формат(ТекОписание.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
			            ТекОписание.Версия,
			            ТекОписание.Имя,
			            ДатаПоследнейВерсии);
			Продолжить;
		КонецЕсли;

		Лог.Информация("[%1]: Обработка версии %2 (%3) конфигурации %4 из шаблона %5",
		               ЭтотОбъект,
		               ТекОписание.Версия,
		               Формат(ТекОписание.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
		               ТекОписание.Имя,
		               ТекОписание.КаталогВерсии);

		Если Служебный.СравнитьВерсии(ТекОписание.Версия, ПоследняяВерсии) <= 0 Тогда
			Лог.Информация("[%1]: Версия %2 меньше или равна предыдущей версии %3 и не будет выгружена",
			               ЭтотОбъект,
			               ТекОписание.Версия,
			               ПоследняяВерсии);
			Продолжить;
		КонецЕсли;

		ПоследняяВерсии = ТекОписание.Версия;
	
		ДатаКоммита = Служебный.ДатаPOSIX(ТекОписание.Дата);
		
		ВерсииДляОбновления = СтрСоединить(ТекОписание.ВерсииДляОбновления, ", ");
		СообщениеКоммита = СтрШаблон("Обновление версии конфигурации поставщика на %2%5%5
		                             |Страница релиза:%5%1%3%5Версии для обновления: %4",
		                             ПараметрыПриложения.СервисРелизов(),
		                             ТекОписание.Версия,
		                             ТекОписание.Путь,
		                             ВерсииДляОбновления,
		                             Символы.ПС);

		Выгрузка = Новый ВыгрузкаКонфигурацииВГит();
		Выгрузка.УстановитьПараметрОбработкиДанных("ВерсияПлатформы"        , ВерсияПлатформы);
		Выгрузка.УстановитьПараметрОбработкиДанных("ПутьККонфигурации",
		                                           ОбъединитьПути(ТекОписание.КаталогВерсии, ИмяФайлаКонфигурации));
		Выгрузка.УстановитьПараметрОбработкиДанных("РепозитарийГит"          , РепозитарийГит);
		Выгрузка.УстановитьПараметрОбработкиДанных("ИмяВеткиГит"             , ИмяВеткиГит);
		Выгрузка.УстановитьПараметрОбработкиДанных("ИмяАвтора"               , ИмяАвтора);
		Выгрузка.УстановитьПараметрОбработкиДанных("ПочтаАвтора"             , ПочтаАвтора);
		Выгрузка.УстановитьПараметрОбработкиДанных("ДатаКоммита"             , ДатаКоммита);
		Выгрузка.УстановитьПараметрОбработкиДанных("СообщениеКоммита"        , СообщениеКоммита);
		Выгрузка.УстановитьПараметрОбработкиДанных("База_СтрокаСоединения"   , База_СтрокаСоединения);
		Выгрузка.УстановитьПараметрОбработкиДанных("КонвертироватьВФорматЕДТ", КонвертироватьВФорматЕДТ);
		Выгрузка.УстановитьПараметрОбработкиДанных("ВерсияЕДТ"               , ВерсияЕДТ);
		Выгрузка.УстановитьПараметрОбработкиДанных("ПутьКЕДТ"                , ПутьКЕДТ);
		Выгрузка.УстановитьПараметрОбработкиДанных("СнятьСПоддержки"         , СнятьСПоддержки);
		Выгрузка.УстановитьПараметрОбработкиДанных("ОтносительныйПуть"       , ОтносительныйПуть);
		Выгрузка.УстановитьПараметрОбработкиДанных("ПутьКСпискуОбъектов"     , ПутьКСпискуОбъектов);
		Выгрузка.ОбработатьДанные();
		
		ПродолжениеОбработкиДанныхВызовМенеджера(ТекОписание);
	КонецЦикла;

	Лог.Информация("[%1]: Выгрузка каталога конфигураций %2 в GIT завершена.",
	               ЭтотОбъект,
	               ПутьККаталогуКонфигураций);
	
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

	Команда.Опция("p path", "", "путь к каталогу содержащему версии конфигурации
	                            |для выгрузки в git")
	       .ТСтрока()
	       .ВОкружении("YARD_CF_PATH");

	Команда.Опция("cf cf-name", "1Cv8.cf", "имя файла конфигурации")
	       .ТСтрока()
	       .ВОкружении("YARD_CF_NAME");

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

	УстановитьПараметрОбработкиДанных("ВерсияПлатформы"          , Команда.ЗначениеОпции("v8version"));
	УстановитьПараметрОбработкиДанных("ПутьККаталогуКонфигураций", Команда.ЗначениеОпции("path"));
	УстановитьПараметрОбработкиДанных("ИмяФайлаКонфигурации"     , Команда.ЗначениеОпции("cf-name"));
	УстановитьПараметрОбработкиДанных("РепозитарийГит"           , Команда.ЗначениеОпции("git-path"));
	УстановитьПараметрОбработкиДанных("ИмяВеткиГит"              , Команда.ЗначениеОпции("git-branch"));
	УстановитьПараметрОбработкиДанных("ИмяАвтора"                , Команда.ЗначениеОпции("git-author"));
	УстановитьПараметрОбработкиДанных("ПочтаАвтора"              , Команда.ЗначениеОпции("git-author-email"));
	УстановитьПараметрОбработкиДанных("База_СтрокаСоединения"    , Команда.ЗначениеОпции("ibconnection"));
	УстановитьПараметрОбработкиДанных("КонвертироватьВФорматЕДТ" , Команда.ЗначениеОпции("convert-to-edt"));
	УстановитьПараметрОбработкиДанных("СнятьСПоддержки"          , Команда.ЗначениеОпции("remove-support"));
	УстановитьПараметрОбработкиДанных("ОтносительныйПуть"    	 , Команда.ЗначениеОпции("src-relative-path"));
	УстановитьПараметрОбработкиДанных("ПутьКСпискуОбъектов"      , Команда.ЗначениеОпции("object-list-file"));

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

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
