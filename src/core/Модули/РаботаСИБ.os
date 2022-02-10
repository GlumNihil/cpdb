// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/cpdb/
// ----------------------------------------------------------

#Использовать v8runner
#Использовать v8storage

Перем Лог;           // - Объект    - объект записи лога приложения

#Область ПрограммныйИнтерфейс

// Выполняет выгрузку информационной базы в DT-файл
//
// Параметры:
//   ПараметрыИБ                    - Строка    - параметры подключения к базе 1С
//      * СтрокаПодключения           - Строка    - строка подключения к базе 1С
//      * Пользователь                - Строка    - имя пользователя базы 1С
//      * Пароль                      - Строка    - пароль пользователя базы 1С
//   ПутьКФайлу                     - Строка    - путь к DT-файлу для выгрузки базы 1С
//   ИспользуемаяВерсияПлатформы    - Строка    - маска версии 1С
//   КлючРазрешения                 - Строка    - ключь разрешения входа в заблоrированную серверную базу 1С (/UC)
//
Процедура ВыгрузитьИнформационнуюБазуВФайл(Знач ПараметрыИБ,
                                           Знач ПутьКФайлу,
                                           Знач ИспользуемаяВерсияПлатформы,
                                           Знач КлючРазрешения = "") Экспорт

	Конфигуратор = НастроитьКонфигуратор(ПараметрыИБ.СтрокаПодключения,
	                                     ПараметрыИБ.Пользователь,
	                                     ПараметрыИБ.Пароль,
	                                     ИспользуемаяВерсияПлатформы);
	
	Если НЕ ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	Лог.Информация("Начало выгрузки информационной базы %1 в файл %2.",
	               ПараметрыИБ.СтрокаПодключения,
	               ПутьКФайлу);

	Попытка
		Конфигуратор.ВыгрузитьИнформационнуюБазу(ПутьКФайлу);

		Лог.Информация("Информационная база %1 выгружена в файл %2.",
		               ПараметрыИБ.СтрокаПодключения,
		               ПутьКФайлу);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка выгрузки базы %1 в файл %2: %3%4",
		                        ПараметрыИБ.СтрокаПодключения,
		                        ПутьКФайлу,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ВыгрузитьИнформационнуюБазуВФайл()

// Выполняет загрузку информационной базы из DT-файла
//
// Параметры:
//   ПараметрыИБ                    - Строка    - параметры подключения к базе 1С
//      * СтрокаПодключения           - Строка    - строка подключения к базе 1С
//      * Пользователь                - Строка    - имя пользователя базы 1С
//      * Пароль                      - Строка    - пароль пользователя базы 1С
//   ПутьКФайлу                     - Строка    - путь к DT-файлу для выгрузки базы 1С
//   ИспользуемаяВерсияПлатформы    - Строка    - маска версии 1С
//   КлючРазрешения                 - Строка    - ключь разрешения входа в заблоrированную серверную базу 1С (/UC)
//
Процедура ЗагрузитьИнформационнуюБазуИзФайла(Знач ПараметрыИБ,
                                             Знач ПутьКФайлу,
                                             Знач ИспользуемаяВерсияПлатформы,
                                             Знач КлючРазрешения = "") Экспорт

	Конфигуратор = НастроитьКонфигуратор(ПараметрыИБ.СтрокаПодключения,
	                                     ПараметрыИБ.Пользователь,
	                                     ПараметрыИБ.Пароль,
	                                     ИспользуемаяВерсияПлатформы);

	Если НЕ ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	Лог.Информация("Начало загрузки информационной базы %1 из файла %2.",
	               ПараметрыИБ.СтрокаПодключения,
	               ПутьКФайлу);

	Попытка
		Конфигуратор.ЗагрузитьИнформационнуюБазу(ПутьКФайлу);

		Лог.Информация("Информационная база %1 загружена из файла %2.",
		               ПараметрыИБ.СтрокаПодключения,
		               ПутьКФайлу);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка загрузки базы %1 из файла %2: %3%4",
		                        ПараметрыИБ.СтрокаПодключения,
		                        ПутьКФайлу,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ЗагрузитьИнформационнуюБазуИзФайла()

// Выполняет отключение информационной базы от хранилища конфигурации
//
// Параметры:
//   ПараметрыИБ                    - Строка    - параметры подключения к базе 1С
//      * СтрокаПодключения           - Строка    - строка подключения к базе 1С
//      * Пользователь                - Строка    - имя пользователя базы 1С
//      * Пароль                      - Строка    - пароль пользователя базы 1С
//   ИспользуемаяВерсияПлатформы    - Строка    - маска версии 1С
//   ИмяРасширения                  - Строка    - имя расширения, отключаемого от хранилища
//                                                (если не указано, отключается основная конфигурация)
//   КлючРазрешения                 - Строка    - ключь разрешения входа в заблоrированную серверную базу 1С (/UC)
//
Процедура ОтключитьОтХранилища(ПараметрыИБ,
                               Знач ИспользуемаяВерсияПлатформы,
                               Знач ИмяРасширения = "",
                               Знач КлючРазрешения = "") Экспорт

	Конфигуратор = НастроитьКонфигуратор(ПараметрыИБ.СтрокаПодключения,
                                         ПараметрыИБ.Пользователь,
                                         ПараметрыИБ.Пароль,
                                         ИспользуемаяВерсияПлатформы);

	Если НЕ ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	МенеджерХранилища = Новый МенеджерХранилищаКонфигурации(, Конфигуратор);

	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
		МенеджерХранилища.УстановитьРасширениеХранилища(ИмяРасширения);
		ТекстОписанияБазы = СтрШаблон("расширения ""%1"" информационной базы ""%2""",
		                              ИмяРасширения,
		                              ПараметрыИБ.СтрокаПодключения);
	Иначе
		ТекстОписанияБазы = СтрШаблон("информационной базы ""%1""", ПараметрыИБ.СтрокаПодключения);
	КонецЕсли;

	Лог.Информация("Начало отключения %1 от хранилища.",
	               ТекстОписанияБазы);
	
	Попытка
		МенеджерХранилища.ОтключитьсяОтХранилища();

		Лог.Информация("Выполнено отключение %1 от хранилища.",
		               ТекстОписанияБазы);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка отключения %1 от хранилища: %2%3",
		                        ТекстОписанияБазы,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ОтключитьОтХранилища()

// Выполняет отключение информационной базы от хранилища конфигурации
//
// Параметры:
//   ПараметрыИБ                    - Структура    - параметры подключения к базе 1С
//      * СтрокаПодключения           - Строка       - строка подключения к базе 1С
//      * Пользователь                - Строка       - имя пользователя базы 1С
//      * Пароль                      - Строка       - пароль пользователя базы 1С
//   ПараметрыХранилища             - Структура    - параметры подключения к хранилищу конфигурации
//      * Адрес                       - Строка       - адрес хранилища конфигурации
//      * Пользователь                - Строка       - имя пользователя хранилища конфигурации
//      * Пароль                      - Строка       - пароль пользователя хранилища конфигурации
//   ИспользуемаяВерсияПлатформы    - Строка       - маска версии 1С
//   ИмяРасширения                  - Строка       - имя расширения, отключаемого от хранилища
//                                                   (если не указано, отключается основная конфигурация)
//   ОбновитьИБ                     - Булево       - Истина - после обновления обновить конфигурацию базы данных
//   КлючРазрешения                 - Строка       - ключь разрешения входа в заблоrированную серверную базу 1С (/UC)
//
Процедура ПодключитьКХранилищу(Знач ПараметрыИБ,
                               Знач ПараметрыХранилища,
                               Знач ИспользуемаяВерсияПлатформы,
                               Знач ИмяРасширения = "",
                               Знач ОбновитьИБ = Ложь,
                               Знач КлючРазрешения = "") Экспорт

	Конфигуратор = НастроитьКонфигуратор(ПараметрыИБ.СтрокаПодключения,
	                                     ПараметрыИБ.Пользователь,
	                                     ПараметрыИБ.Пароль,
	                                     ИспользуемаяВерсияПлатформы);
	
	Если Не ПустаяСтрока(КлючРазрешения) Тогда
		Конфигуратор.УстановитьКлючРазрешенияЗапуска(КлючРазрешения);
	КонецЕсли;

	МенеджерХранилища = Новый МенеджерХранилищаКонфигурации(ПараметрыХранилища.Адрес, Конфигуратор);
	
	Если ЗначениеЗаполнено(ПараметрыХранилища.Пользователь) Тогда
		МенеджерХранилища.УстановитьПараметрыАвторизации(ПараметрыХранилища.Пользователь, ПараметрыХранилища.Пароль);
	КонецЕсли;

	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
		МенеджерХранилища.УстановитьРасширениеХранилища(ИмяРасширения);
		ТекстОписанияБазы = СтрШаблон("расширения ""%1"" информационной базы ""%2""",
		                              ИмяРасширения,
		                              ПараметрыИБ.СтрокаПодключения);
	Иначе
		ТекстОписанияБазы = СтрШаблон("информационной базы ""%1""", ПараметрыИБ.СтрокаПодключения);
	КонецЕсли;

	Лог.Информация("Начало подключения %1 к хранилищу %2.",
	               ТекстОписанияБазы,
	               ПараметрыХранилища.Адрес);

	Попытка
		МенеджерХранилища.ПодключитьсяКХранилищу(Истина);

		// Иногда проявляется проблема, что при подключении
		// выполняется получение не последней версии конфигурации.
		// Для контроля получаем конфигурацию из хранилища.
		МенеджерХранилища.ОбновитьКонфигурациюНаВерсию();

		Если ОбновитьИБ Тогда
			Конфигуратор.ОбновитьКонфигурациюБазыДанных();
		КонецЕсли;

		Лог.Информация("Выполнено подключение %1 к хранилищу %2.",
		               ТекстОписанияБазы,
		               ПараметрыХранилища.Адрес);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка подключения %1 к хранилищу %2: %3%4",
		                        ТекстОписанияБазы,
		                        ПараметрыХранилища.Адрес,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // ПодключитьКХранилищу()

// Создание серверной информационной базы 1С
//
// Параметры:
//  ПараметрыБазы1С             - Структура
//     * Сервер1С                 - Строка     - Адрес кластера серверов 1С ([<протокол>://]<адрес>[:<порт>])
//     * ИмяИБ                    - Строка     - Имя информационной базы на сервере 1С
//     * РазрешитьВыдачуЛицензий  - Булево     - Истина - разрешить выдачу лицензий сервером 1С (по умолчанию: Истина)
//     * РазрешитьРегЗадания      - Булево     - Истина - разрешить запуск рег. заданий (по умолчанию: Ложь)
//  ПараметрыСУБД               - Структура
//     * ТипСУБД                  - Строка     - Тип сервера СУБД ("MSSQLServer" <по умолчанию>; "PostgreSQL"; "IBMDB2"; "OracleDatabase")
//     * СерверСУБД               - Строка     - Адрес сервера СУБД
//     * ПользовательСУБД         - Строка     - Пользователь сервера СУБД
//     * ПарольСУБД               - Строка     - Пароль пользователя сервера СУБД
//     * ИмяБД                    - Строка     - Имя базы на сервере СУБД (если не указано будет использовано имя ИБ 1С)
//     * СмещениеДат              - Строка     - Смещение дат на сервере MS SQL (0; 2000 <по умолчанию>)
//     * СоздаватьБД              - Булево     - Истина - будет создана база на сервере СУБД в случае отсутствия (по умолчанию: Ложь)
//  АвторизацияВКластере        - Структура
//     * Имя                      - Строка     - Имя администратора кластера 1С
//     * Пароль                   - Строка     - Пароль администратора кластера 1С
//  ИспользуемаяВерсияПлатформы - Строка       - маска версии 1С
//  ОшибкаЕслиСуществует        - Булево     - Истина - Вызвать исключение если ИБ в кластере 1С существует (по умолчанию: Ложь)
//  ПутьКШаблону                - Строка     - Путь к шаблону для создания информационной базы (*.cf; *.dt).
//                                             Если шаблон не указан, то будет создана пустая ИБ
//  ИмяБазыВСписке 	            - Строка     - Имя в списке баз пользователя (если не задано, то ИБ в список не добавляется)
//
Процедура СоздатьСервернуюБазу(Знач Параметры1С,
                               Знач ПараметрыСУБД,
                               Знач АвторизацияВКластере,
                               Знач ИспользуемаяВерсияПлатформы = "",
                               Знач ОшибкаЕслиСуществует = Ложь,
                               Знач ПутьКШаблону = "",
                               Знач ИмяВСпискеБаз = "") Экспорт

	Конфигуратор = Новый УправлениеКонфигуратором();
	Конфигуратор.ИспользоватьВерсиюПлатформы(ИспользуемаяВерсияПлатформы);
	
	Лог.Информация("Начало создания базы ""%1"" на сервере ""%2""",
	               Параметры1С.ИмяИБ,
	               Параметры1С.Сервер1С);
	Попытка
		Конфигуратор.СоздатьСервернуюБазу(Параметры1С,
		                                  ПараметрыСУБД,
		                                  АвторизацияВКластере,
		                                  ОшибкаЕслиСуществует,
		                                  ПутьКШаблону,
		                                  ИмяВСпискеБаз);

		Лог.Информация("Выполнено создание базы ""%1"" на сервере ""%2""",
		               Параметры1С.ИмяИБ,
		               Параметры1С.Сервер1С);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Ошибка создания базы ""%1"" на сервере ""%2"": %3%4",
		                        Параметры1С.ИмяИБ,
		                        Параметры1С.Сервер1С,
		                        Символы.ПС,
		                        ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

КонецПроцедуры // СоздатьСервернуюБазу()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Функция подготавливает конфигуратор 1С для выполнения в режиме командной строки
//   
// Параметры:
//   СтрокаПодключения              - Строка    - строка подключения к базе 1С
//   ИмяПользователя                - Строка    - имя пользователя базы 1С
//   ПарольПользователя             - Строка    - пароль пользователя базы 1С
//   ИспользуемаяВерсияПлатформы    - Строка    - маска версии 1С
//
// Возвращаемое значение:
//   Строка    - Обработанная строка
//
Функция НастроитьКонфигуратор(СтрокаПодключения,
                              ИмяПользователя = Неопределено,
                              ПарольПользователя = Неопределено,
                              ИспользуемаяВерсияПлатформы = Неопределено)
	
	Конфигуратор = Новый УправлениеКонфигуратором;

	КаталогСборки = КаталогВременныхФайлов();

	Конфигуратор.КаталогСборки(КаталогСборки);

	Если ЗначениеЗаполнено(СтрокаПодключения) Тогда
		Конфигуратор.УстановитьКонтекст(СтрокаПодключения, ИмяПользователя, ПарольПользователя);
	КонецЕсли;

	Если НЕ ИспользуемаяВерсияПлатформы = Неопределено Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ИспользуемаяВерсияПлатформы);
	КонецЕсли;

	Возврат Конфигуратор;

КонецФункции // НастроитьКонфигуратор()

#КонецОбласти // СлужебныеПроцедурыИФункции

Лог = ПараметрыСистемы.Лог();
