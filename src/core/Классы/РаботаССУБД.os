// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------

Перем ПодключениеКСУБД;  // - ПодключениеКСУБД    - объект подключения к СУБД
Перем Лог;               // - Объект              - объект записи лога приложения

#Область ПрограммныйИнтерфейс

// Проверяет существование базу на сервере СУБД
//
// Параметры:
//   База        - Строка    - имя базы
//
// Возвращаемое значение:
//   Булево    - Истина - база существует
//
Функция БазаСуществует(База) Экспорт

	Попытка
		Результат = ПодключениеКСУБД.БазаСуществует(База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка проверки существования базы ""%1"":%2%3",
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

	Возврат Результат;

КонецФункции // БазаСуществует()

// Создает базу данных
//   
// Параметры:
//   База                    - Строка    - имя базы
//   МодельВосстановления    - Строка    - новая модель восстановления (FULL, SIMPLE, BULK_LOGGED)
//   ПутьККаталогу           - Строка    - путь к каталогу для размещения файлов базы данных
//                                         если не указан, то файлы размещаются в каталоге по умолчанию SQL Server
//
Процедура СоздатьБазуДанных(База, МодельВосстановления = "FULL", ПутьККаталогу = "") Экспорт

	Лог.Информация("Начало создания базы ""%1\%2""",
	               ПодключениеКСУБД.Сервер(),
	               База);

	ОписаниеРезультата = "";
	
	Попытка
		Результат = ПодключениеКСУБД.СоздатьБазу(База, МодельВосстановления, ПутьККаталогу, ОписаниеРезультата);

		Если Результат Тогда
			Лог.Информация("Создана база данных ""%1\%2"":%3%4",
			               ПодключениеКСУБД.Сервер(),
			               База,
			               Символы.ПС,
			               ОписаниеРезультата);
		Иначе
			ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1\%2"":%3%4",
			                        ПодключениеКСУБД.Сервер(),
			                        База,
			                        Символы.ПС,
			                        ОписаниеРезультата); 
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1\%2"":%3%4",
		                        ПодключениеКСУБД.Сервер(),
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // СоздатьБазуДанных()

// Удаляет базу данных
//   
// Параметры:
//   База                    - Строка    - имя базы
//
Процедура УдалитьБазуДанных(База) Экспорт

	Лог.Информация("Начало удаления базы ""%1\%2""",
	               ПодключениеКСУБД.Сервер(),
	               База);

	ОписаниеРезультата = "";
	
	Попытка
		Результат = ПодключениеКСУБД.УдалитьБазу(База, ОписаниеРезультата);

		Если Результат Тогда
			Лог.Информация("Удалена база данных ""%1\%2"":%3%4",
			               ПодключениеКСУБД.Сервер(),
			               База,
			               Символы.ПС,
			               ОписаниеРезультата);
		Иначе
			ТекстОшибки = СтрШаблон("Ошибка удаления базы данных ""%1\%2"":%3%4",
			                        ПодключениеКСУБД.Сервер(),
			                        База,
			                        Символы.ПС,
			                        ОписаниеРезультата); 
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка удаления базы данных ""%1\%2"":%3%4",
		                        ПодключениеКСУБД.Сервер(),
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // УдалитьБазуДанных()

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

// Получает текущего владельца базы
//   
// Параметры:
//   База    - Строка    - имя базы данных
//
// Возвращаемое значение:
//   Строка    - имя текущего владельца базы
//
Функция ПолучитьВладельца(База) Экспорт

	Попытка
		Результат = ПодключениеКСУБД.ПолучитьВладельцаБазы(База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка получения владельца базы ""%1"":%2%3",
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

	Возврат Результат;

КонецФункции // ПолучитьВладельца()

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
		ТекстОшибки = СтрШаблон("Ошибка смены владельца базы ""%1"" на ""%2"":%3%4",
		                        База,
		                        ВладелецБазы,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ИзменитьВладельца()

// Получает модель восстановления базы (FULL, SIMPLE, BULK_LOGGED)
//
// Параметры:
//   База    - Строка    - имя базы данных
//
// Возвращаемое значение:
//   Строка    - текущая модель восстановления базы
//
Функция ПолучитьМодельВосстановления(База) Экспорт

	Попытка
		Результат = ПодключениеКСУБД.ПолучитьМодельВосстановления(База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка получения модели восстановления базы ""%1"":%2%3",
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

	Возврат Результат;

КонецФункции // ПолучитьМодельВосстановления()

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
		ТекстОшибки = СтрШаблон("Ошибка смены модели восстановления базы ""%1"" на ""%2"":%3%4",
		                        База,
		                        МодельВосстановления,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ИзменитьМодельВосстановления()

// Получает логическое имя файла в базе
//   
// Параметры:
//   База        - Строка    - имя базы данных
//   ТипФайла    - Строка    - ROWS - файл базы; LOG - файл журнала транзакций
//
// Возвращаемое значение:
//   Строка     - логическое имя файла в базе данных
//
Функция ПолучитьЛогическоеИмяФайла(База, ТипФайла = "ROWS") Экспорт

	ТипФайлаПредставление = "неизвестного типа";

	Если ВРег(ТипФайла) = "ROWS" ИЛИ ВРег(ТипФайла) = "D" Тогда
		ТипФайлаПредставление = "данных";
	ИначеЕсли ВРег(ТипФайла) = "LOG" ИЛИ ВРег(ТипФайла) = "L" Тогда
		ТипФайлаПредставление = "журнала";
	КонецЕсли;

	Попытка
		Результат = ПодключениеКСУБД.ПолучитьЛогическоеИмяФайлаВБазе(База, ТипФайла);

		Если Результат = Неопределено Тогда
			ТекстОшибки = СтрШаблон("Ошибка получения логического имени файла %1 в базе ""%2""",
			                        ТипФайлаПредставление,
			                        База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка получения логического имени файла %1 в базе ""%2"":%3%4",
		                        ТипФайлаПредставление,
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Возврат Результат;

КонецФункции // ПолучитьЛогическоеИмяФайла()

// Устанавливает новое логическое имя файла базы
//
// Параметры:
//   База        - Строка    - имя базы данных
//   Имя         - Строка    - логическое имя изменяемого файла
//   НовоеИмя    - Строка    - новое логическое имя
//
Процедура ИзменитьЛогическоеИмяФайла(База, Имя, НовоеИмя) Экспорт

	Если Имя = НовоеИмя Тогда
		Возврат;
	КонецЕсли;

	Попытка
		Результат = ПодключениеКСУБД.ИзменитьЛогическоеИмяФайлаВБазе(База, Имя, НовоеИмя);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла ""%1"" на ""%2"" в базе ""%3""",
			                        Имя,
			                        НовоеИмя,
			                        База);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Лог.Информация("Изменено логическое имя файла ""%1"" на ""%2"" в базе ""%3""",
		               Имя,
		               НовоеИмя,
		               База);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла ""%1"" на ""%2"" в базе ""%3"":%4%5",
		                        Имя,
		                        НовоеИмя,
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры // ИзменитьЛогическоеИмяФайла()

// Устанавливает логические имена файлов в формате:
//   <НовоеИмя> - для файла данных
//   <НовоеИмя>_log - для файла журнала транзакций
//
// Параметры:
//   База        - Строка    - имя базы данных
//   НовоеИмя    - Строка    - новое имя файлов, если не указано, то используется имя базы данных
//
Процедура УстановитьЛогическиеИменаФайлов(База, Знач НовоеИмя = "") Экспорт

	Если НЕ ЗначениеЗаполнено(НовоеИмя) Тогда
		НовоеИмя = База;
	КонецЕсли;

	Попытка
		ЛИФ = ПолучитьЛогическоеИмяФайла(База, "ROWS");
		НовоеЛИФ = НовоеИмя;

		ИзменитьЛогическоеИмяФайла(База, ЛИФ, НовоеЛИФ);

		Лог.Информация("Изменено логическое имя файла данных с ""%1"" на ""%2"" в базе ""%3""",
		               База,
		               ЛИФ,
		               НовоеЛИФ);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла данных с ""%1"" на ""%2"" в базе ""%3"":%4%5",
		                        ЛИФ,
		                        НовоеЛИФ,
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Попытка
		ЛИФ = ПолучитьЛогическоеИмяФайла(База, "LOG");
		НовоеЛИФ = СтрШаблон("%1_log", НовоеИмя);

		ИзменитьЛогическоеИмяФайла(База, ЛИФ, НовоеЛИФ);

		Лог.Информация("Изменено логическое имя файла журнала транзакций с ""%1"" на ""%2"" в базе ""%3""",
		               База,
		               ЛИФ,
		               НовоеЛИФ);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла журнала транзакций
		                        |с ""%1"" на ""%2"" в базе ""%3"":%4%5",
		                        ЛИФ,
		                        НовоеЛИФ,
		                        База,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // УстановитьЛогическиеИменаФайлов()

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
Процедура СжатьФайлЖурналаТранзакций(База) Экспорт

	Лог.Информация("Начало сжатия (shrink) файла журнала транзакций базы ""%1""", База);
		
	Попытка
		ОписаниеРезультата = "";

		Результат = ПодключениеКСУБД.СжатьФайлЖурналаТранзакций(База, ОписаниеРезультата);

		Если НЕ Результат Тогда
			ТекстОшибки = СтрШаблон("Ошибка сжатия файла журнала транзакций базы ""%1"":%2%3",
			                        База,
			                        Символы.ПС,
			                        ОписаниеРезультата);
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

КонецПроцедуры // СжатьФайлЖурналаТранзакций()

// Функция выполняет указанные скрипты
//
// Параметры:
//    СкриптыВыполнения  - Строка - пути к файлам скриптов, разделенные ";"
//    СтрокаПеременных   - Строка - набор значений переменных в виде "<Имя>=<Значение>", разделенные ";"
//
// Возвращаемое значение:
//    Строка    - результат выполнения скриптов
//
Функция ВыполнитьСкрипты(СкриптыВыполнения, СтрокаПеременных = "") Экспорт
	
	МассивСкриптов = СтрРазделить(СкриптыВыполнения, ";", Ложь);
	МассивПеременных = СтрРазделить(СтрокаПеременных, ";", Ложь);
	
	ОписаниеРезультата = "";
	
	КодВозврата = ПодключениеКСУБД.ВыполнитьСкриптыЗапросСУБД(МассивСкриптов, МассивПеременных, ОписаниеРезультата);
	Если КодВозврата = 0 Тогда
		Если ЗначениеЗаполнено(ОписаниеРезультата) Тогда
			Лог.Отладка("Результат выполнения:%1%2", Символы.ПС, ОписаниеРезультата);
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

	Возврат ОписаниеРезультата;

КонецФункции // ВыполнитьСкрипты()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//    _ПодключениеКСУБД    - ПодключениеКСУБД    - объект подключения к СУБД
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Знач _ПодключениеКСУБД)

	ПодключениеКСУБД = _ПодключениеКСУБД;

	Лог = ПараметрыСистемы.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
