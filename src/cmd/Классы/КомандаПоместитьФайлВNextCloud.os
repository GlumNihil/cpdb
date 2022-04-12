// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------

#Использовать "../../core"

Перем Лог;       // - Объект      - объект записи лога приложения

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("pp params", "", "Файлы JSON содержащие значения параметров,
	                               | могут быть указаны несколько файлов разделенные "";""")
	       .ТСтрока()
	       .ВОкружении("CPDB_PARAMS");

	Команда.Опция("s service", "", "адрес сервиса NextCloud")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_NC_SERVICE");

	Команда.Опция("u user", "", "имя пользователя сервиса NextCloud")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_NC_USER");

	Команда.Опция("n pwd", "", "пароль пользователя сервиса NextCloud")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_NC_PWD");

	Команда.Опция("f file", "", "путь к локальному файлу для помещения на NextCloud")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_NC_PUT_FILE");

	Команда.Опция("l list", "", "путь к локальному файлу со списком файлов,
	                            |которые будут помещены на NextCloud
	                            |(параметр -file игнорируется)")
	       .ТСтрока()
	       .ВОкружении("CPDB_NC_PUT_LIST");

	Команда.Опция("p path", "", "путь к файлу на NextCloud")
	       .ТСтрока()
	       .Обязательный()
	       .ВОкружении("CPDB_NC_PUT_PATH");

	Команда.Опция("r replace", "", "перезаписать файл на сервисе NextCloud при загрузке")
	       .Флаговый()
	       .ВОкружении("CPDB_NC_PUT_REPLACE");

	Команда.Опция("ds delsrc", "", "удалить исходные файлы после отправки")
	       .Флаговый()
	       .ВОкружении("CPDB_NC_PUT_DEL_SRC");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);

	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");

	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ЭтоСписокФайлов = Истина;

	ПутьКФайлу              = ЧтениеОпций.ЗначениеОпции("list");
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПутьКФайлу          = ЧтениеОпций.ЗначениеОпции("file");
		ЭтоСписокФайлов	= Ложь;
	КонецЕсли;
	АдресСервиса            = ЧтениеОпций.ЗначениеОпции("service");
	ИмяПользователя         = ЧтениеОпций.ЗначениеОпции("user");
	ПарольПользователя      = ЧтениеОпций.ЗначениеОпции("pwd");
	ЦелевойПуть             = ЧтениеОпций.ЗначениеОпции("path");
	УдалитьИсточник         = ЧтениеОпций.ЗначениеОпции("delsrc");
	Перезаписывать          = ЧтениеОпций.ЗначениеОпции("replace");
		
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		ВызватьИсключение "Не указан путь к файлу для помещения в сервис NextCloud";
	КонецЕсли;
	
	МассивОтправляемыхФайлов = Новый Массив;
	ФайлИнфо = Новый Файл(ПутьКФайлу);

	Сервис = Новый ПодключениеNextCloud(АдресСервиса, ИмяПользователя, ПарольПользователя);

	// Если целевой путь не указан - тогда используется корень указанного пользователя NextCloud
	Если ЗначениеЗаполнено(ЦелевойПуть) Тогда
		// Определяем наличие каталога
		РаботаСФайлами.СоздатьПапкуВNextCloud(Сервис, ЦелевойПуть);
	Иначе
		ЦелевойПуть = "";
	КонецЕсли;
	
	Если ЭтоСписокФайлов Тогда
		МассивОтправляемыхФайлов = РаботаСФайлами.ПрочитатьСписокФайлов(ПутьКФайлу, Истина);
	КонецЕсли;
	
	// Добавляем файл (или файл-список файлов) списка для закачки в сервис NextCloud
	МассивОтправляемыхФайлов.Добавить(ФайлИнфо.ПолноеИмя);

	Для Каждого ОтправляемыйФайл Из МассивОтправляемыхФайлов Цикл
		РаботаСФайлами.ОтправитьФайлВNextCloud(Сервис, ОтправляемыйФайл, ЦелевойПуть, Перезаписывать);

		Если УдалитьИсточник Тогда
			УдалитьФайлы(ОтправляемыйФайл);
			Лог.Информация("Исходный файл ""%1"" удален", ОтправляемыйФайл);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта()

	Лог = ПараметрыСистемы.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
