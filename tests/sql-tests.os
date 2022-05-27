﻿#Использовать fs
#Использовать "../src/core"

Перем ПодключениеКСУБД;          //    - объект подключения к СУБД
Перем РаботаССУБД;               //    - объект работы с СУБД
Перем ИмяСервера;                //    - имя сервера MS SQL
Перем ПрефиксИмениБД;            //    - префикс имен тестовых баз
Перем ФайлКопииБазы;             //    - путь к файлу копии базы для тестов
Перем КаталогВременныхДанных;    //    - путь к каталогу временных данных
Перем Лог;                       //    - логгер

// Процедура выполняется после запуска теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	КаталогВременныхДанных = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "build", "tmpdata");

	ИмяСервера = ПолучитьПеременнуюСреды("CPDB_SQL_SRVR");
	ИмяПользователя = ПолучитьПеременнуюСреды("CPDB_SQL_USER");
	ПарольПользователя = ПолучитьПеременнуюСреды("CPDB_SQL_PWD");

	ПрефиксИмениБД = "cpdb_test_db_";
	ФайлКопииБазы = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "cpdb_test_db.bak");

	ПодключениеКСУБД = Новый ПодключениеMSSQL(ИмяСервера, ИмяПользователя, ПарольПользователя);
	
	РаботаССУБД = Новый РаботаССУБД(ПодключениеКСУБД);

	Лог = ПараметрыСистемы.Лог();

	Для й = 1 По 3 Цикл
		ИмяБазы = СтрШаблон("%1%2", ПрефиксИмениБД, й);

		Если НЕ РаботаССУБД.БазаСуществует(ИмяБазы) Тогда
			Продолжить;
		КонецЕсли;

		РаботаССУБД.УдалитьБазуДанных(ИмяБазы);
	КонецЦикла;

КонецПроцедуры // ПередЗапускомТеста()

// Процедура выполняется после запуска теста
//
Процедура ПослеЗапускаТеста() Экспорт

КонецПроцедуры // ПослеЗапускаТеста()

&Тест
Процедура ТестДолжен_ПолучитьВерсиюSQLServer() Экспорт

	Результат = ПодключениеКСУБД.ПолучитьВерсиюСУБД();

	Лог.Информация("Версия сервера СУБД: %1", Результат.Представление);
	
	ТекстОшибки = СтрШаблон("Ошибка получения версии MS SQL Server");

	Утверждения.ПроверитьБольше(Найти(ВРег(Результат.Представление), "MICROSOFT"), 0, ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПолучитьВерсиюSQLServer()

&Тест
Процедура ТестДолжен_ПолучитьДоступностьФункционалаSQLServer() Экспорт

	Результат = ПодключениеКСУБД.ДоступностьФункционалаСУБД("Компрессия");

	ТекстОшибки = СтрШаблон("Ошибка получения доступности функционала MS SQL Server");

	Утверждения.ПроверитьИстину(Результат, ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПолучитьДоступностьФункционалаSQLServer()

&Тест
Процедура ТестДолжен_ВыполнитьСценарийСУБДИзФайла() Экспорт

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	ПутьКСкрипту = ОбъединитьПути(КаталогВременныхДанных, "test.sql");
	Скрипт = Новый ТекстовыйДокумент();
	Скрипт.ДобавитьСтроку("SELECT @@VERSION");
	Скрипт.Записать(ПутьКСкрипту);

	Результат = РаботаССУБД.ВыполнитьСкрипты(ПутьКСкрипту);

	ТекстОшибки = СтрШаблон("Ошибка выполнения сценария MS SQL Server");

	Утверждения.ПроверитьБольше(СтрНайти(Результат, "Microsoft SQL Server"), 0, ТекстОшибки);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ВыполнитьСценарийСУБДИзФайла()

&Тест
Процедура ТестДолжен_СоздатьБазуДанных() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);

	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_СоздатьБазуДанных()

&Тест
Процедура ТестДолжен_ПроверитьОшибкуСозданияБазыДанных() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	ВозниклаОшибка = Истина;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка создания существующей базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	МодельВосстановления = "WRONGMODEL";

	ВозниклаОшибка = Неопределено;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.СоздатьБазуДанных(ИмяБД, МодельВосстановления, КаталогВременныхДанных);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка создания базы данных ""%1""
	                        |с некорректной моделью восстановления ""%2""",
	                        ИмяБД,
	                        МодельВосстановления);

	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ПроверитьОшибкуСозданияБазыДанных()

&Тест
Процедура ТестДолжен_УдалитьБазуДанных() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	ТекстОшибки = СтрШаблон("Ошибка удаления базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьЛожь(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_УдалитьБазуДанных()

&Тест
Процедура ТестДолжен_ПроверитьОшибкуУдаленияБазыДанных() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ВозниклаОшибка = Неопределено;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.УдалитьБазуДанных(ИмяБД);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка удаления отсутствующей базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПроверитьОшибкуУдаленияБазыДанных()

&Тест
Процедура ТестДолжен_ПолучитьЛогическоеИмяФайлаВБазе() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	ЛогическоеИмя = РаботаССУБД.ПолучитьЛогическоеИмяФайла(ИмяБД, "ROWS");

	ТекстОшибки = СтрШаблон("Ошибка получения логического имени файла данных базы ""%1""", ИмяБД);

	Утверждения.ПроверитьРавенство(ЛогическоеИмя, ИмяБД, ТекстОшибки);

	ЛогическоеИмя = РаботаССУБД.ПолучитьЛогическоеИмяФайла(ИмяБД, "LOG");

	ТекстОшибки = СтрШаблон("Ошибка получения логического имени файла журнала базы ""%1""", ИмяБД);

	Утверждения.ПроверитьРавенство(ЛогическоеИмя, СтрШаблон("%1_log", ИмяБД), ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ПолучитьЛогическоеИмяФайлаВБазе()

&Тест
Процедура ТестДолжен_ИзменитьЛогическиеИменаФайловВБазе() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	НовоеИмя = СтрШаблон("%1%2", ПрефиксИмениБД, 2);
	
	РаботаССУБД.УстановитьЛогическиеИменаФайлов(ИмяБД, НовоеИмя);

	ЛИФДанные = ПодключениеКСУБД.ПолучитьЛогическоеИмяФайлаВБазе(ИмяБД, "ROWS");
	ЛИФЖурнал = ПодключениеКСУБД.ПолучитьЛогическоеИмяФайлаВБазе(ИмяБД, "LOG");

	ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла данных базы ""%1""на ""%2""",
	                        ИмяБД,
	                        НовоеИмя);

	Утверждения.ПроверитьРавенство(НовоеИмя, ЛИФДанные, ТекстОшибки);

	ТекстОшибки = СтрШаблон("Ошибка изменения логического имени файла журнала транзакций базы ""%1"" на ""%2""",
	                        ИмяБД,
	                        СтрШаблон("%1_log", НовоеИмя));

	Утверждения.ПроверитьРавенство(СтрШаблон("%1_log", НовоеИмя), ЛИФЖурнал, ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ИзменитьЛогическоеИмяФайлаВБазе()

&Тест
Процедура ТестДолжен_СоздатьРезервнуюКопиюБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	ПутьКРезервнойКопии = ОбъединитьПути(КаталогВременныхДанных, СтрШаблон("%1.bak", ИмяБД));

	РаботаССУБД.ВыполнитьРезервноеКопирование(ИмяБД, ПутьКРезервнойКопии);

	ВремФайл = Новый Файл(ПутьКРезервнойКопии);

	ТекстОшибки = СтрШаблон("Ошибка резервного копирования базы ""%1"" в файл ""%2""", ИмяБД, ПутьКРезервнойКопии);

	Утверждения.ПроверитьИстину(ВремФайл.Существует(), ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(ПутьКРезервнойКопии);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_СоздатьРезервнуюКопиюБазы()

&Тест
Процедура ТестДолжен_ПолучитьОшибкуСозданияРезервнойКопииБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 3);

	ПутьКРезервнойКопии = ОбъединитьПути(КаталогВременныхДанных, СтрШаблон("%1.bak", ИмяБД));

	ВозниклаОшибка = Неопределено;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.ВыполнитьРезервноеКопирование(ИмяБД, ПутьКРезервнойКопии);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка резервного копирования базы ""%1"" в файл ""%2""",
	                        ИмяБД,
	                        ПутьКРезервнойКопии);

	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПолучитьОшибкуСозданияРезервнойКопииБазы()

&Тест
Процедура ТестДолжен_ВосстановитьБазуИзРезервнойКопии() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка создания базы данных ""%1""", ИмяБД);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	РаботаССУБД.ВыполнитьВосстановление(ИмяБД,
	                                    ФайлКопииБазы,
	                                    КаталогВременныхДанных,
	                                    КаталогВременныхДанных,
	                                    Истина);
	
	ТекстОшибки = СтрШаблон("Ошибка восстановления базы ""%1"" из резервной копии ""%2""", ИмяБД, ФайлКопииБазы);

	Утверждения.ПроверитьИстину(РаботаССУБД.БазаСуществует(ИмяБД), ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ВосстановитьБазуИзРезервнойКопии()

&Тест
Процедура ТестДолжен_ПолучитьОшибкуВосстановленияБазыИзРезервнойКопии() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 2);

	ПутьКРезервнойКопии = ОбъединитьПути(КаталогВременныхДанных, СтрШаблон("%1.bak", ИмяБД));

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ВозниклаОшибка = Неопределено;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.ВыполнитьВосстановление(ИмяБД,
	                                                            ПутьКРезервнойКопии,
	                                                            КаталогВременныхДанных,
	                                                            КаталогВременныхДанных,
	                                                            Истина);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка восстановления ""%1"" из файла ""%2""", ИмяБД, ПутьКРезервнойКопии);
	
	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

КонецПроцедуры // ТестДолжен_ПолучитьОшибкуВосстановленияБазыИзРезервнойКопии()

&Тест
Процедура ТестДолжен_ИзменитьВладельцаБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);
	ВладелецДо = ПодключениеКСУБД.Пользователь();
	ВладелецПосле = "sa";

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	Владелец = РаботаССУБД.ПолучитьВладельца(ИмяБД);

	ТекстОшибки = СтрШаблон("Ошибка получения владельца базы ""%1""", ИмяБД);

	Утверждения.ПроверитьРавенство(Владелец, ВладелецДо, ТекстОшибки);

	РаботаССУБД.ИзменитьВладельца(ИмяБД, ВладелецПосле);

	Владелец = РаботаССУБД.ПолучитьВладельца(ИмяБД);

	ТекстОшибки = СтрШаблон("Ошибка изменения владельца базы ""%1"" на ""%2""", ИмяБД, ВладелецПосле);

	Утверждения.ПроверитьРавенство(Владелец, ВладелецПосле, ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ИзменитьВладельцаБазы()

&Тест
Процедура ТестДолжен_ИзменитьМодельВосстановленияБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);
	МодельВосстановленияДо = "SIMPLE";
	МодельВосстановленияПосле = "FULL";

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, МодельВосстановленияДо, КаталогВременныхДанных);

	МодельВосстановления = РаботаССУБД.ПолучитьМодельВосстановления(ИмяБД);

	ТекстОшибки = СтрШаблон("Ошибка проверки модели восстановления базы ""%1""", ИмяБД);

	Утверждения.ПроверитьРавенство(МодельВосстановления, МодельВосстановленияДо, ТекстОшибки);

	РаботаССУБД.ИзменитьМодельВосстановления(ИмяБД, МодельВосстановленияПосле);

	МодельВосстановления = РаботаССУБД.ПолучитьМодельВосстановления(ИмяБД);

	ТекстОшибки = СтрШаблон("Ошибка установки модели восстановления ""%1"" базы ""%2""", МодельВосстановленияПосле, ИмяБД);

	Утверждения.ПроверитьРавенство(МодельВосстановления, МодельВосстановленияПосле, ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ИзменитьМодельВосстановленияБазы()

&Тест
Процедура ТестДолжен_ПолучитьОшибкуИзмененияМоделиВосстановленияБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);
	МодельВосстановленияПосле = "WRONGMODEL";

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	ВозниклаОшибка = Неопределено;

	Попытка
		ВозниклаОшибка = НЕ РаботаССУБД.ИзменитьМодельВосстановления(ИмяБД, МодельВосстановленияПосле);
	Исключение
		ВозниклаОшибка = Истина;
	КонецПопытки;

	ТекстОшибки = СтрШаблон("Ожидалась ошибка установки модели восстановления ""%1"" базы ""%2""",
	                        МодельВосстановленияПосле,
	                        ИмяБД);

	Утверждения.ПроверитьИстину(ВозниклаОшибка, ТекстОшибки);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ПолучитьОшибкуИзмененияМоделиВосстановленияБазы()

&Тест
Процедура ТестДолжен_ВыполнитьКомпрессиюБазы() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	РаботаССУБД.ВключитьКомпрессию(ИмяБД);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_ВыполнитьКомпрессиюБазы()

&Тест
Процедура ТестДолжен_СжатьБазу() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	РаботаССУБД.СжатьБазу(ИмяБД);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_СжатьБазу()

&Тест
Процедура ТестДолжен_СжатьФайлЖурналаТранзакций() Экспорт

	ИмяБД = СтрШаблон("%1%2", ПрефиксИмениБД, 1);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	РаботаССУБД.СоздатьБазуДанных(ИмяБД, , КаталогВременныхДанных);

	РаботаССУБД.СжатьФайлЖурналаТранзакций(ИмяБД);

	РаботаССУБД.УдалитьБазуДанных(ИмяБД);

	УдалитьФайлы(КаталогВременныхДанных);

КонецПроцедуры // ТестДолжен_СжатьФайлЖурналаТранзакций()

