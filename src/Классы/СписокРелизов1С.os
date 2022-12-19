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

Перем ИмяПользователя;          // Строка                 - имя пользователя сайта релизов 1С
Перем ПарольПользователя;       // Строка                 - пароль пользователя сайта релизов 1С

Перем ФильтрПриложений;         // Массив(Строка)         - фильтр имен приложений
Перем ФильтрВерсий;             // Массив(Строка)         - фильтр номеров версий
Перем ФильтрВерсийНачинаяСДаты; // Дата                   - фильтр по начальной дате версии (включая)
Перем ФильтрВерсийДоДаты;       // Дата                   - фильтр по последней дате версии (включая)
Перем ПолучатьБетаВерсии;       // Булево                 - Истина - будут получены ознакомительные версии
                                //                          Ложь - будут получены только релизные версии
Перем ПутьКФайлуДляСохранения;  // Строка                 - путь к фалу (json) для сохранения списка приложений и версий

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
	                          "ИмяПользователя",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Имя пользователя сайта релизов 1С");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ПарольПользователя",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Пароль пользователя сайта релизов 1С");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрПриложений",
	                          "Массив",
	                          Ложь,
	                          "",
	                          "Фильтр имен приложений");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсий",
	                          "Массив",
	                          Ложь,
	                          "",
	                          "Фильтр номеров версий");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсийНачинаяСДаты",
	                          "Дата",
	                          Ложь,
	                          "",
	                          "Фильтр по начальной дате версии (включая)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсийДоДаты",
	                          "Дата",
	                          Ложь,
	                          "",
	                          "Фильтр по последней дате версии (включая)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПолучатьБетаВерсии",
	                          "Булево",
	                          Ложь,
	                          Истина,
	                          "Если установлен будут получены ознакомительные версии
	                          |в противном случае будут получены только релизные версии");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьКФайлуДляСохранения",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "путь к фалу (json) для сохранения списка приложений и версий");

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
	
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяПользователя"         , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПарольПользователя"      , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФильтрВерсийНачинаяСДаты", ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФильтрВерсийДоДаты"      , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПолучатьБетаВерсии"      , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьКФайлуДляСохранения" , ПараметрыОбработки);

	ФильтрПриложений = Новый Массив();
	Если ПараметрыОбработки.Свойство("ФильтрПриложений") Тогда
		Если ТипЗнч(ПараметрыОбработки.ФильтрПриложений) = Тип("Массив") Тогда
			ФильтрПриложений = ПараметрыОбработки.ФильтрПриложений;
		Иначе
			ФильтрПриложений = СтрРазделить(ПараметрыОбработки.ФильтрПриложений, "|");
		КонецЕсли;
	КонецЕсли;

	ФильтрВерсий = Новый Массив();
	Если ПараметрыОбработки.Свойство("ФильтрВерсий") Тогда
		Если ТипЗнч(ПараметрыОбработки.ФильтрВерсий) = Тип("Массив") Тогда
			ФильтрВерсий = ПараметрыОбработки.ФильтрВерсий;
		Иначе
			ФильтрВерсий = СтрРазделить(ПараметрыОбработки.ФильтрВерсий, "|");
		КонецЕсли;
	КонецЕсли;

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

	Если ВРег(ИмяПараметра) = "ФИЛЬТРПРИЛОЖЕНИЙ" Тогда
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			ФильтрПриложений = Значение;
		Иначе
			ФильтрПриложений = СтрРазделить(Значение, "|", Ложь);
		КонецЕсли;
	ИначеЕсли ВРег(ИмяПараметра) = "ФИЛЬТРВЕРСИЙ" Тогда
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			ФильтрВерсий = Значение;
		Иначе
			ФильтрВерсий = СтрРазделить(Значение, "|", Ложь);
		КонецЕсли;
	ИначеЕсли ВРег(ИмяПараметра) = "ПУТЬКФАЙЛУДЛЯСОХРАНЕНИЯ" Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьКФайлуДляСохранения = ВремФайл.ПолноеИмя;
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
	
	Обозреватель = Новый ОбозревательСайта1С(ИмяПользователя, ПарольПользователя);

	НакопленныеДанные = Обозреватель.ПолучитьСписокПриложений(ФильтрПриложений,
	                                                          ФильтрВерсий,
	                                                          ФильтрВерсийНачинаяСДаты,
	                                                          ФильтрВерсийДоДаты,
	                                                          ПолучатьБетаВерсии);

	Для Каждого ТекЭлемент Из НакопленныеДанные Цикл
		ВерсииПриложения = Обозреватель.ПолучитьВерсииПриложения(ТекЭлемент.Путь,
		                                                         ФильтрВерсий,
		                                                         ФильтрВерсийНачинаяСДаты,
		                                                         ФильтрВерсийДоДаты);
		Для Каждого ТекВерсия Из ВерсииПриложения Цикл

			ТекВерсия.Вставить("Имя"            , ТекЭлемент.Имя);
			ТекВерсия.Вставить("Идентификатор"  , ТекЭлемент.Идентификатор);
			ТекВерсия.Вставить("ПолныйДистрибутив",
			                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Полный дистрибутив$"));
			ТекВерсия.Вставить("ДистрибутивОбновления",
			                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Дистрибутив обновления$"));
		КонецЦикла;

		Если ПолучатьБетаВерсии Тогда
			Для Каждого ТекВерсия Из ТекЭлемент.БетаВерсии Цикл
				ТекВерсия.Вставить("Имя"            , ТекЭлемент.Имя);
				ТекВерсия.Вставить("Идентификатор"  , ТекЭлемент.Идентификатор);
				ТекВерсия.Вставить("ПолныйДистрибутив",
				                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Полный дистрибутив$"));
				ТекВерсия.Вставить("ДистрибутивОбновления",
				                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Дистрибутив обновления$"));
				
				ВерсииПриложения.Добавить(ТекВерсия);
			КонецЦикла;
		КонецЕсли;

		ТекЭлемент.Вставить("Версии", ВерсииПриложения);

		ПродолжениеОбработкиДанныхВызовМенеджера(ТекЭлемент);
	КонецЦикла;

	ЗавершениеОбработкиДанных();

КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Если ЗначениеЗаполнено(ПутьКФайлуДляСохранения) Тогда
		СохранитьОписанияВФайл();
	Иначе
		ВывестиПриложенияСВерсиями();
	КонецЕсли;

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
	
	Команда.Опция("af app-filter", "", "фильтр приложений")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_APP_FILTER");

	Команда.Опция("vf version-filter", "", "фильтр версий")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_VERSION_FILTER");

	Команда.Опция("vsd version-start-date", "", "фильтр по начальной дате версии (включая)")
	       .ТДата("dd.MM.yyyy")
	       .ВОкружении("YARD_RELEASES_VERSION_START_DATE");

	Команда.Опция("ved version-end-date", "", "фильтр по последней дате версии (включая)")
	       .ТДата("dd.MM.yyyy")
	       .ВОкружении("YARD_RELEASES_VERSION_END_DATE");

	Команда.Опция("bv get-beta-versions", Ложь, "флаг получения версий для ознакомления")
	       .Флаг();

	Команда.Опция("o output-file", "", "путь к фалу (json) для сохранения списка приложений и версий")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_FILE");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	УстановитьПараметрОбработкиДанных("ИмяПользователя"          , Команда.ЗначениеОпции("user"));
	УстановитьПараметрОбработкиДанных("ПарольПользователя"       , Команда.ЗначениеОпции("password"));

	ВремФильтрПриложений = Команда.ЗначениеОпции("app-filter");
	Служебный.УбратьКавычки(ВремФильтрПриложений);
	УстановитьПараметрОбработкиДанных("ФильтрПриложений"         , ВремФильтрПриложений);

	ВремФильтрВерсий = Команда.ЗначениеОпции("version-filter");
	Служебный.УбратьКавычки(ВремФильтрВерсий);
	УстановитьПараметрОбработкиДанных("ФильтрВерсий"             , ВремФильтрВерсий);

	УстановитьПараметрОбработкиДанных("ФильтрВерсийНачинаяСДаты" , Команда.ЗначениеОпции("version-start-date"));
	УстановитьПараметрОбработкиДанных("ФильтрВерсийДоДаты"       , Команда.ЗначениеОпции("version-end-date"));
	УстановитьПараметрОбработкиДанных("ПолучатьБетаВерсии"       , Команда.ЗначениеОпции("get-beta-versions"));
	УстановитьПараметрОбработкиДанных("ПутьКФайлуДляСохранения"  , Команда.ЗначениеОпции("output-file"));

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

	ПараметрыОбработчиков.ОбработатьПараметрыАвторизации(ИмяПараметра, ЗначениеПараметра);

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

Процедура СохранитьОписанияВФайл()

	Если НЕ ЗначениеЗаполнено(ПутьКФайлуДляСохранения) Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ТипЗнч(НакопленныеДанные) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если НакопленныеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Распаковщик.ОбеспечитьКаталог(ПутьКФайлуДляСохранения, Истина);
	
	Запись = Новый ЗаписьJSON();
	
	Запись.ОткрытьФайл(ПутьКФайлуДляСохранения, "UTF-8", , Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));
	
	Лог.Информация("[%1]: Запись данных в файл ""%2""", ТипЗнч(ЭтотОбъект), ПутьКФайлуДляСохранения);

	Попытка
		ЗаписатьJSON(Запись, НакопленныеДанные);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Запись.Закрыть();

КонецПроцедуры // СохранитьОписанияВФайл()

Процедура ВывестиПриложенияСВерсиями()

	СтрокаПробелов = "                                              ";
	СтрокаРазделитель = "----------------------------------------------------------------------";

	ДлинаСвойстваПриложения = 0;
	ДлинаСвойстваВерсии = 0;
	
	Для Каждого ТекЭлемент Из НакопленныеДанные Цикл
		
		ВывестиСвойстваЭлемента(ТекЭлемент, ДлинаСвойстваПриложения, "Версии");

		Если ТекЭлемент.Версии.Количество() > 0 Тогда
			ТекКлюч = "Версии";
			ТекКлюч = ТекКлюч + Лев(СтрокаПробелов, ДлинаСвойстваПриложения - СтрДлина(ТекКлюч));
			Сообщить(СтрШаблон("%1: ", ТекКлюч));
		КонецЕсли;

		Для Каждого ТекВерсия Из ТекЭлемент.Версии Цикл
		
			ВывестиСвойстваЭлемента(ТекВерсия, ДлинаСвойстваВерсии, , 2);

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры // ВывестиПриложенияСВерсиями()

Процедура ВывестиСвойстваЭлемента(ОписаниеЭлемента,
                                  МаксДлинаСвойства = 0,
                                  Знач ПропуститьСвойства = "",
                                  Знач Отступ = 0)

	СтрокаПробелов = "                                              ";
	СтрокаРазделитель = "----------------------------------------------------------------------";

	Для й = 1 По Отступ - 1 Цикл
		СтрокаРазделитель = Символы.Таб + СтрокаРазделитель;
	КонецЦикла;
	
	Если МаксДлинаСвойства = 0 Тогда
		МаксДлинаСвойства = МаксДлинаКлючаСтруктуры(ОписаниеЭлемента);
	КонецЕсли;

	ПропускаемыеСвойства = СтрРазделить(ПропуститьСвойства, ",", Ложь);

	Сообщить(СтрШаблон("%1%2", Символы.ПС, СтрокаРазделитель));

	Для Каждого ТекСвойство Из ОписаниеЭлемента Цикл
		
		Если НЕ ПропускаемыеСвойства.Найти(ТекСвойство.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ТекЗначение = ТекСвойство.Значение;
		Если ТипЗнч(ТекЗначение) = Тип("Массив") Тогда
			ТекЗначение = СтрСоединить(ТекЗначение, ", ");
		КонецЕсли;
		
		ТекКлюч = ТекСвойство.Ключ + Лев(СтрокаПробелов, МаксДлинаСвойства - СтрДлина(ТекСвойство.Ключ));
		
		СтрокаДляВывода = СтрШаблон("%1 : %2", ТекКлюч, ТекЗначение);

		Для й = 1 По Отступ Цикл
			СтрокаДляВывода = Символы.Таб + СтрокаДляВывода;
		КонецЦикла;

		Сообщить(СтрокаДляВывода);

	КонецЦикла;

КонецПроцедуры // ВывестиСвойстваЭлемента()

Функция МаксДлинаКлючаСтруктуры(ПарамСтруктура)

	МаксДлина = 0;
	Для Каждого ТекЭлемент Из ПарамСтруктура Цикл
		МаксДлина = Макс(МаксДлина, СтрДлина(ТекЭлемент.Ключ));
	КонецЦикла;

	Возврат МаксДлина;

КонецФункции // МаксДлинаКлючаСтруктуры()

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
