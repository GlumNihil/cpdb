// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------

Перем ПодключениеКСУБД;  // - ПодключениеКСУБД    - объект подключения к СУБД
Перем Лог;               // - Объект    - объект записи лога приложения

#Область ПрограммныйИнтерфейс

// Выполняет резервное копирование базы
//   
// Параметры:
//   База                    - Строка             - имя базы
//   ПутьКРезервнойКопии     - Строка             - путь к файлу резервной копии
//
Процедура ВыполнитьРезервноеКопирование(База, ПутьКРезервнойКопии) Экспорт

	Лог.Информация("Начало создания резервной копии ""%1"" базы ""%2\%3""",
	               ПутьКРезервнойКопии,
	               ПодключениеКСУБД.Сервер(),
	               База);

	ОписаниеРезультата = "";
	
	Попытка
		Результат = ПодключениеКСУБД.СоздатьРезервнуюКопию(База, ПутьКРезервнойКопии, ОписаниеРезультата);

		Если Не ПустаяСтрока(ОписаниеРезультата) Тогда
			Лог.Информация("Вывод команды: " + ОписаниеРезультата);
		КонецЕсли;
		
		Если Результат Тогда
			Лог.Информация("Создана резервная копия ""%1"" базы ""%2\%3"": %4%5",
			               ПутьКРезервнойКопии,
			               ПодключениеКСУБД.Сервер(),
			               База,
			               Символы.ПС,
			               ОписаниеРезультата);
		Иначе
			ТекстОшибки = СтрШаблон("Ошибка создания резервной копии ""%1"" базы ""%2\%3"": %4%5",
			                        ПутьКРезервнойКопии,
			                        ПодключениеКСУБД.Сервер(),
			                        База,
			                        Символы.ПС,
			                        ОписаниеРезультата); 
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка создания резервной копии ""%1"" базы ""%2\%3"": %4%5",
		                        ПутьКРезервнойКопии,
		                        ПодключениеКСУБД.Сервер(),
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ВыполнитьРезервноеКопирование()

// Выполняет восстановление базы из резервной копии
//   
// Параметры:
//   База                    - Строка             - имя базы
//   ПутьКРезервнойКопии     - Строка             - путь к файлу резервной копии
//   ПутьКФайлуДанных        - Строка             - путь к файлу данных базы
//   ПутьКФайлуЖурнала       - Строка             - путь к файлу журнала транзакций базы
//   СоздаватьБазу           - Булево             - Истина - создать базу в случае отсутствия
//
Процедура ВыполнитьВосстановление(База,
                                  ПутьКРезервнойКопии,
                                  ПутьКФайлуДанных,
                                  ПутьКФайлуЖурнала,
                                  СоздаватьБазу) Экспорт

	Лог.Информация("Начало восстановления базы ""%1\%2"" из резервной копии ""%3""",
	               ПодключениеКСУБД.Сервер(),
	               База,
	               ПутьКРезервнойКопии);

	ОписаниеРезультата = "";

	Попытка
		Результат = ПодключениеКСУБД.ВосстановитьИзРезервнойКопии(База,
		                                                          ПутьКРезервнойКопии,
		                                                          ПутьКФайлуДанных,
		                                                          ПутьКФайлуЖурнала,
		                                                          СоздаватьБазу,
		                                                          ОписаниеРезультата);

		Если Результат Тогда
			Лог.Информация("Выполнено восстановление базы ""%1"" из резервной копии ""%2"": %3",
			               База,
			               ПутьКРезервнойКопии,
			               ОписаниеРезультата);
		Иначе
			ТекстОшибки = СтрШаблон("Ошибка восстановления базы ""%1"" из резервной копии ""%2"": %3%4",
			                        База,
			                        ПутьКРезервнойКопии,
			                        Символы.ПС,
			                        ОписаниеРезультата); 
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка восстановления базы ""%1"" из резервной копии ""%2"": %3%4",
		                        База,
		                        ПутьКРезервнойКопии,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ВыполнитьВосстановление()

// Удаляет файл-источник резервной копии
//   
// Параметры:
//   ПутьКРезервнойКопии     - Строка   - путь к файлу резервной копии
//
Процедура УдалитьИсточник(ПутьКРезервнойКопии) Экспорт

	Попытка
		УдалитьФайлы(ПутьКРезервнойКопии);
		Лог.Информация("Исходный файл %1 удален", ПутьКРезервнойКопии);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка удаления файла %1: %2",
		                        ПутьКРезервнойКопии,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // УдалитьИсточник()

// Устанавливает нового владельца базы
//   
// Параметры:
//   База                - Строка             - имя базы
//   ВладелецБазы        - Строка             - новый владелец базы
//
Процедура ИзменитьВладельца(База, ВладелецБазы) Экспорт

	Попытка
		Результат = ПодключениеКСУБД.УстановитьВладельцаБазы(База, ВладелецБазы);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка смены владельца базы ""%1"" на ""%2""",
			                        База,
			                        ВладелецБазы);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Для базы ""%1"" установлен новый владелец ""%2""",
		               База,
		               ВладелецБазы);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка смены владельца базы ""%1"" на ""%2"": %3",
		                        База,
		                        ВладелецБазы,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ИзменитьВладельца()

// Устанавливает модель восстановления базы (FULL, SIMPLE, BULK_LOGGED)
//   
// Параметры:
//   База                   - Строка             - имя базы
//   МодельВосстановления   - Строка             - новая модель восстановления (FULL, SIMPLE, BULK_LOGGED)
//
Процедура ИзменитьМодельВосстановления(База, МодельВосстановления) Экспорт

	Попытка
		Результат = ПодключениеКСУБД.УстановитьМодельВосстановления(База, МодельВосстановления);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка смены модели восстановления базы ""%1"" на ""%2""",
			                        База,
			                        МодельВосстановления);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Для базы ""%1"" установлена модель восстановления ""%2""",
		               База,
		               МодельВосстановления);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка смены модели восстановления базы ""%1"" на ""%2"": %3",
		                        База,
		                        МодельВосстановления,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ИзменитьМодельВосстановления()

// Устанавливает логические имена файлов базы в соответствии с именем базы
//   
// Параметры:
//   ПодключениеКСУБД    - ПодключениеКСУБД   - объект подключения к СУБД
//   База                - Строка             - имя базы
//
Процедура ИзменитьЛогическиеИменаФайлов(База) Экспорт

	Попытка
		ЛИФ = ПодключениеКСУБД.ПолучитьЛогическоеИмяФайлаВБазе(База, "ROWS");
		НовоеЛИФ = База;
		Результат = ПодключениеКСУБД.ИзменитьЛогическоеИмяФайлаБазы(База, ЛИФ, НовоеЛИФ);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла данных ""%1"" в базе ""%2""",
			                        ЛИФ,
			                        База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Для базы ""%1"" изменено логическое имя файла данных ""%2"" на ""%3""",
		               База,
		               ЛИФ,
		               НовоеЛИФ);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла данных ""%1"" в базе ""%2"": %3",
		                        ЛИФ,
		                        База,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Попытка
		ЛИФ = ПодключениеКСУБД.ПолучитьЛогическоеИмяФайлаВБазе(База, "LOG");
		НовоеЛИФ = База + "_log";
		Результат = ПодключениеКСУБД.ИзменитьЛогическоеИмяФайлаБазы(База, ЛИФ, НовоеЛИФ);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла журнала ""%1"" в базе ""%2""",
			                        ЛИФ,
			                        База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Для базы ""%1"" изменено логическое имя файла журнала ""%2"" на ""%3""",
		               База,
		               ЛИФ,
		               НовоеЛИФ);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла журнала ""%1"" в базе ""%2"": %3",
		                        ЛИФ,
		                        База,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ИзменитьЛогическиеИменаФайлов()

// Включает компрессию данных базы на уровне страниц
//   
// Параметры:
//   База                - Строка             - имя базы
//
Процедура ВключитьКомпрессию(База) Экспорт

	Лог.Информация("Начало компрессии страниц базы ""%1""", База);
		
	Попытка
		Результат = ПодключениеКСУБД.ВключитьКомпрессиюСтраниц(База);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка включения компрессии страниц в базе ""%1""", База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Включена компрессия страниц в базе ""%1""", База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка включения компрессии страниц в базе ""%1"": ""%2""",
		                        База,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ВключитьКомпрессию()

// Выполняет сжатие базы (shrink)
//   
// Параметры:
//   База                - Строка             - имя базы
//
Процедура СжатьБазу(База) Экспорт

	Лог.Информация("Начало сжатия (shrink) файла данных базы ""%1""", База);
		
	Попытка
		Результат = ПодключениеКСУБД.СжатьБазу(База);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка сжатия файла данных базы ""%1""", База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Выполнено сжатие файла данных базы ""%1""", База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка сжатия файла данных базы ""%1"":%2%3",
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // СжатьБазу()

// Выполняет сжатие файла лога (shrink)
//   
// Параметры:
//   База                - Строка             - имя базы
//
Процедура СжатьФайлЛог(База) Экспорт

	Лог.Информация("Начало сжатия (shrink) файла журнала транзакций базы ""%1""", База);
		
	Попытка
		Результат = ПодключениеКСУБД.СжатьФайлЛог(База);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка сжатия файла журнала транзакций базы ""%1""", База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Выполнено сжатие файла журнала транзакций базы ""%1""", База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка сжатия файла журнала транзакций базы ""%1"":%2%3",
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // СжатьФайлЛог()

// Функция выполняет указанные скрипты
//
// Параметры:
//    СкриптыВыполнения  - Строка - Имя базы данных
//    СтрокаПеременных   - Строка - путь к файлу резервной копии
//
Процедура ВыполнитьСкрипты(СкриптыВыполнения, СтрокаПеременных) Экспорт
	
	МассивСкриптов = СтрРазделить(СкриптыВыполнения, ";", Ложь);
	МассивПеременных = СтрРазделить(СтрокаПеременных, ";", Ложь);
	
	ОписаниеРезультата = "";
	
	КодВозврата = ПодключениеКСУБД.ВыполнитьСкриптыЗапросСУБД(МассивСкриптов, МассивПеременных, ОписаниеРезультата);
	Если КодВозврата = 0 Тогда
		Если ЗначениеЗаполнено(ОписаниеРезультата) Тогда
			Лог.Информация(ОписаниеРезультата);
		КонецЕсли;
	Иначе
		ТекстОшибки = СтрШаблон("Ошибка выполнения скриптов ""%1"" для значений переменных ""%2""
		                        |на сервере ""%3"", код возврата %4: %5%6",
		                        СкриптыВыполнения,
		                        СтрокаПеременных,
		                        ПодключениеКСУБД.Сервер(),
		                        КодВозврата,
		                        Символы.ПС,
		                        ОписаниеРезультата); 
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

КонецПроцедуры // ВыполнитьСкрипты()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Знач _ПодключениеКСУБД)

	ПодключениеКСУБД = _ПодключениеКСУБД;

	Лог = ПараметрыСистемы.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
