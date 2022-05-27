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
Процедура ТестДолжен_СоздатьПапкуВNextCloud() Экспорт

	АдресСервиса = ПолучитьПеременнуюСреды("NC_TEST_ADDRESS");
	АдминИмя     = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_NAME");
	АдминПароль  = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_PWD");

	Клиент = Новый РаботаСNextCloud(АдресСервиса, АдминИмя, АдминПароль);

	ИмяКаталога = "testFolder1";

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" в сервисе ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.Удалить(ИмяКаталога);

КонецПроцедуры // ТестДолжен_СоздатьПапкуВNextCloud()

&Тест
Процедура ТестДолжен_ОтправитьФайлВNextCloud() Экспорт

	АдресСервиса = ПолучитьПеременнуюСреды("NC_TEST_ADDRESS");
	АдминИмя     = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_NAME");
	АдминПароль  = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_PWD");

	Клиент = Новый РаботаСNextCloud(АдресСервиса, АдминИмя, АдминПароль);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" в сервисе ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" в сервис ""%2"", для пользователя ""%3""",
	                        ТестовыйФайл.ПолноеИмя,
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя)), ТекстОшибки);

	Клиент.Удалить(ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя));

	Клиент.Удалить(ИмяКаталога);

КонецПроцедуры // ТестДолжен_ОтправитьФайлВNextCloud()

&Тест
Процедура ТестДолжен_ПолучитьФайлИзNextCloud() Экспорт

	АдресСервиса = ПолучитьПеременнуюСреды("NC_TEST_ADDRESS");
	АдминИмя     = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_NAME");
	АдминПароль  = ПолучитьПеременнуюСреды("NC_TEST_ADMIN_PWD");

	Клиент = Новый РаботаСNextCloud(АдресСервиса, АдминИмя, АдминПароль);

	ИмяКаталога = "testFolder1";

	ТестовыйФайл = Новый Файл(ПутьКТестовомуФайлу);

	Клиент.СоздатьКаталог(ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка создания каталога ""%1"" в сервисе ""%2"", для пользователя ""%3""",
	                        ИмяКаталога,
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ИмяКаталога), ТекстОшибки);

	Клиент.ОтправитьФайл(ТестовыйФайл.ПолноеИмя, ИмяКаталога);

	ТекстОшибки = СтрШаблон("Ошибка отправки файла ""%1"" в сервис ""%2"", для пользователя ""%3""",
	                        ТестовыйФайл.ПолноеИмя,
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(Клиент.Существует(ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя)), ТекстОшибки);

	ФС.ОбеспечитьКаталог(КаталогВременныхДанных);
	
	Клиент.ПолучитьФайл(ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя),
	                                       КаталогВременныхДанных);

	ТекстОшибки = СтрШаблон("Ошибка получения файла ""%1"" из сервиса ""%2"", для пользователя ""%3""",
	                        ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя),
	                        АдресСервиса,
	                        АдминИмя);

	Утверждения.ПроверитьИстину(ТестовыйФайл.Существует(), ТекстОшибки);

	Клиент.Удалить(ОбъединитьПути(ИмяКаталога, ТестовыйФайл.Имя));

	Клиент.Удалить(ИмяКаталога);

КонецПроцедуры // ТестДолжен_ПолучитьФайлИзNextCloud()

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
