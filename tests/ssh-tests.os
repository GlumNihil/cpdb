﻿#Использовать fs
#Использовать "../src/core"
#Использовать "../src/cmd"

Перем ПутьКТестовомуФайлу;       //    - путь к файлу для тестов
Перем КаталогВременныхДанных;    //    - путь к каталогу временных данных
Перем Лог;                       //    - логгер

#Область ОбработчикиСобытий

// Процедура выполняется после запуска теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	КаталогВременныхДанных = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "build", "tmpdata");
	КаталогВременныхДанных = ФС.ПолныйПуть(КаталогВременныхДанных);

	ПутьКТестовомуФайлу = ОбъединитьПути(КаталогВременныхДанных, "testFile1.tst");

	Лог = ПараметрыСистемы.Лог();
	Лог.УстановитьУровень(УровниЛога.Информация);

КонецПроцедуры // ПередЗапускомТеста()

// Процедура выполняется после запуска теста
//
Процедура ПослеЗапускаТеста() Экспорт

КонецПроцедуры // ПослеЗапускаТеста()

#КонецОбласти // ОбработчикиСобытий

#Область Тесты

&Тест
Процедура ТестДолжен_СоздатьФайл() Экспорт

	ФС.ОбеспечитьПустойКаталог(КаталогВременныхДанных);

	РазмерФайла = 31457280;
	
	СоздатьСлучайныйФайл(ПутьКТестовомуФайлу, РазмерФайла);

	ТекстОшибки = СтрШаблон("Ошибка создания файла ""%1""", ПутьКТестовомуФайлу);

	Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьКТестовомуФайлу), ТекстОшибки);

КонецПроцедуры // ТестДолжен_СоздатьФайл()

&Тест
Процедура ТестДолжен_СоздатьПапкуНаSFTP() Экспорт

	АдресСервера       = ПолучитьПеременнуюСреды("SFTP_TEST_ADDRESS");
	ПользовательИмя    = ПолучитьПеременнуюСреды("SFTP_TEST_USER");
	ПользовательПароль = ПолучитьПеременнуюСреды("SFTP_TEST_PWD");

	Клиент = Новый РаботаССерверомSSH(АдресСервера, ПользовательИмя, ПользовательПароль);

	ИмяКаталога = "testFolder1";

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" на сервере ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервера,
	                        ПользовательИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.УдалитьКаталог(ИмяКаталога);

КонецПроцедуры // ТестДолжен_СоздатьПапкуНаSFTP()

&Тест
Процедура ТестДолжен_ОтправитьФайлНаSFTP() Экспорт

	АдресСервера       = ПолучитьПеременнуюСреды("SFTP_TEST_ADDRESS");
	ПользовательИмя    = ПолучитьПеременнуюСреды("SFTP_TEST_USER");
	ПользовательПароль = ПолучитьПеременнуюСреды("SFTP_TEST_PWD");

	Клиент = Новый РаботаССерверомSSH(АдресСервера, ПользовательИмя, ПользовательПароль);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" на сервере ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервера,
	                        ПользовательИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" на сервер ""%2"", для пользователя ""%3""",
	                        ТестовыйФайл.ПолноеИмя,
	                        АдресСервера,
	                        ПользовательИмя);

	ПутьКФайлу = СтрШаблон("%1/%2", ИмяКаталога, ТестовыйФайл.Имя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ПутьКФайлу), ТекстОшибки);

	Клиент.УдалитьФайл(ПутьКФайлу);

	Клиент.УдалитьКаталог(ИмяКаталога);

КонецПроцедуры // ТестДолжен_ОтправитьФайлНаSFTP()

&Тест
Процедура ТестДолжен_ПолучитьФайлСSFTP() Экспорт

	АдресСервера       = ПолучитьПеременнуюСреды("SFTP_TEST_ADDRESS");
	ПользовательИмя    = ПолучитьПеременнуюСреды("SFTP_TEST_USER");
	ПользовательПароль = ПолучитьПеременнуюСреды("SFTP_TEST_PWD");

	Клиент = Новый РаботаССерверомSSH(АдресСервера, ПользовательИмя, ПользовательПароль);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" на сервере ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервера,
	                        ПользовательИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" на сервер ""%2"", для пользователя ""%3""",
	                        ТестовыйФайл.ПолноеИмя,
	                        АдресСервера,
	                        ПользовательИмя);

	ПутьКФайлу = СтрШаблон("%1/%2", ИмяКаталога, ТестовыйФайл.Имя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ПутьКФайлу), ТекстОшибки);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	Клиент.ПолучитьФайл(ПутьКФайлу, КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка получения файла ""%1"" с сервера ""%2"", для пользователя ""%3""",
	                        ПутьКФайлу,
	                        АдресСервера,
	                        ПользовательИмя);

	Утверждения.ПроверитьИстину(ТестовыйФайл.Существует(), ТекстОшибки);

	Клиент.УдалитьФайл(ПутьКФайлу);

	Клиент.УдалитьКаталог(ИмяКаталога);

КонецПроцедуры // ТестДолжен_ПолучитьФайлСSFTP()

&Тест
Процедура ТестДолжен_УдалитьТестовыйКаталог() Экспорт

	УдалитьФайлы(КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка удаления каталога временных файлов ""%1""", КаталогВременныхДанных);

	Утверждения.ПроверитьЛожь(ФС.ФайлСуществует(КаталогВременныхДанных), ТекстОшибки);

КонецПроцедуры // ТестДолжен_УдалитьТестовыйКаталог()

#КонецОбласти // Тесты

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьСлучайныйФайл(ПутьКФайлу, РазмерФайла)

	Если ФС.ФайлСуществует(ПутьКФайлу) Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;

	НачальноеЧисло = 1113;
	ДлинаЧисла     = 8;
	ГраницаГСЧ     = 4294836225;
	
	ЧастейЗаписи     = 100;
	МаксПорцияЗаписи = 10485760;
	ПорцияЗаписи     = 1024;
	Если Цел(РазмерФайла / ЧастейЗаписи) <= МаксПорцияЗаписи Тогда
		ПорцияЗаписи = Цел(РазмерФайла / ЧастейЗаписи);
	Иначе
		ПорцияЗаписи = МаксПорцияЗаписи;
	КонецЕсли;

	ГСЧ = Новый ГенераторСлучайныхЧисел(НачальноеЧисло);

	ЗаписьДанных = Новый ЗаписьДанных(ПутьКФайлу);

	Записано = 0;

	Пока Записано < РазмерФайла Цикл
		Число = ГСЧ.СлучайноеЧисло(0, ГраницаГСЧ);

		ЗаписьДанных.ЗаписатьЦелое64(Число);

		Записано = Записано + ДлинаЧисла;
		Если Записано % ПорцияЗаписи = 0 Тогда
			ЗаписьДанных.СброситьБуферы();
		КонецЕсли;
	КонецЦикла;

	ЗаписьДанных.Закрыть();

КонецПроцедуры // СоздатьФайл()

#КонецОбласти // СлужебныеПроцедурыИФункции
