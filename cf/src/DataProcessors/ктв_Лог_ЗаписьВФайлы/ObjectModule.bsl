
#Область ПрограммныйИнтерфейс

// Функция - Подтверждает, что обработка является обработкой обслуживания
// 
// Возвращаемое значение:
//  Булево - Истина
//
Функция ЭтоОбработкаЛогирования() Экспорт
	
	Возврат Истина;
	
КонецФункции //ЭтоОбработкаЛогирования()

// Функция - определяет, что способ логирования позволяет вывод лога на клиенте
// 
// Возвращаемое значение:
//  Булево - Истина
//
Функция ВыводитьНаКлиенте() Экспорт
	
	Возврат Ложь;
	
КонецФункции //ВыводитьНаКлиенте()

// Функция - определяет, что способ логирования позволяет вывод лога на сервере
// 
// Возвращаемое значение:
//  Булево - Истина
//
Функция ВыводитьНаСервере() Экспорт
	
	Возврат Истина;
	
КонецФункции //ВыводитьНаСервере()

// Функция - Получает форму обработчиков команд, где расположены процедуры-обработчики команд
// 			 из списка действий кнопки открытия поля выбора обработки обслуживания
// 
// Возвращаемое значение:
//  Строка - Имя формы обработчиков комманд
//
Функция ПолучитьФормуОбработчиковКоманд() Экспорт
	
	Возврат "Форма";
	
КонецФункции //ПолучитьФормуОбработчиковКоманд()

// Функция - Получает список действий кнопки открытия поля выбора обработки обслуживания
// 
// Возвращаемое значение:
//  СписокЗначений - Список действий
//
Функция ПолучитьСписокДействийКнопкиОткрытия() Экспорт
	
	СписокДействий = Новый СписокЗначений();
	СписокДействий.Добавить("ВыполнитьКоманду_КаталогЛогированияОткрытие(Неопределено, Ложь)", "Открыть каталог логов...", , БиблиотекаКартинок.ОткрытьФайл);	
	СписокДействий.Добавить("ОткрытьФорму_Форма", "Настройка...", , БиблиотекаКартинок.ИзменитьФорму);	
	
	Возврат СписокДействий;
	
КонецФункции //ПолучитьСписокДействийКнопкиОткрытия()

// Процедура выполняет запись в журнал регистрации 1С
//
// Параметры:
//	Текст					- Строка					- текст выводимого сообщения
//	СпособЛогирования		- СправочникСсылка.			- ссылка на способ логирования
//							  ктв_СпособыЛогирования
//	ПараметрыЗаписи			- Структура					- параметры записи информации в журнал регистрации
//
Процедура ЗаписатьВЛог(Текст, СпособЛогирования, ПараметрыЗаписи) Экспорт
	
	УровниЛога = ктв_Логирование.УровниЛога();
	
	ВремУровень = "ИНФОРМАЦИЯ";
	
	Если ПараметрыЗаписи.Свойство("УровеньЛога") Тогда
		
		Если ПараметрыЗаписи.УровеньЛога = УровниЛога.Отладка Тогда
			ВремУровень = "ОТЛАДКА";
		ИначеЕсли ПараметрыЗаписи.УровеньЛога = УровниЛога.Информация Тогда
			ВремУровень = "ИНФОРМАЦИЯ";
		ИначеЕсли ПараметрыЗаписи.УровеньЛога = УровниЛога.Предупреждение Тогда
			ВремУровень = "ПРЕДУПРЕЖДЕНИЕ";
		ИначеЕсли ПараметрыЗаписи.УровеньЛога = УровниЛога.Ошибка Тогда
			ВремУровень = "ОШИБКА";
		ИначеЕсли ПараметрыЗаписи.УровеньЛога = УровниЛога.КритичнаяОшибка Тогда
			ВремУровень = "КРИТИЧНАЯ ОШИБКА";
		КонецЕсли;
	КонецЕсли;
	
	ТекущийПользователь = СокрЛП(ПользователиИнформационнойБазы.ТекущийПользователь());
	
	Если ПараметрыЗаписи.Свойство("ТекущийПользователь") Тогда
		ТекущийПользователь = ПараметрыЗаписи.ТекущийПользователь;
	КонецЕсли;
	
	ТекстЗаписи = СокрЛП(ТекущаяДата()) + " (" + ТекущаяУниверсальнаяДатаВМиллисекундах() + ") <" + ТекущийПользователь + ">: " + ВремУровень + " - " + Текст;
	
	Настройка = СпособЛогирования.ОбработкаНастройки.Получить();
	
	Если НЕ ТипЗнч(Настройка) = Тип("Структура") Тогда
		ПараметрыЗаписи.Вставить("ТекстОшибки", СтрШаблон("Не указаны настройки способа логирования ""%1""!", СокрЛП(СпособЛогирования)));
		Возврат;
	КонецЕсли;
	
	Если НЕ Настройка.Свойство("КаталогЛогирования") Тогда
		ПараметрыЗаписи.Вставить("ТекстОшибки", СтрШаблон("Не указан каталог логирования для способа ""%1""!", СокрЛП(СпособЛогирования)));
		Возврат;
	КонецЕсли;
	
	МаксРазмерФайла = 0;
	Если Настройка.Свойство("МаксРазмерФайла") Тогда
		МаксРазмерФайла = Настройка.МаксРазмерФайла;
	КонецЕсли;
	
	ИмяФайлаЛога = ПолучитьИмяФайлаЛога(Настройка.КаталогЛогирования, МаксРазмерФайла);
	
	мФайлЛога = Новый ЗаписьТекста(ИмяФайлаЛога, "UTF-8", , Истина);

	мФайлЛога.ЗаписатьСтроку(ТекстЗаписи);

	мФайлЛога.Закрыть();
	
КонецПроцедуры //ЗаписатьВЛог()

#КонецОбласти

#Область СлужебныеПроцедуры

// Функция - возвращает путь к актуальному файлу лога
//
// Параметры:
//  КаталогЛогирования			 - Строка		 - путь к каталогу логов
//  МаксРазмерФайла				 - Число		 - максимальный размер файла логов в байтах
// 
// Возвращаемое значение:
// 	Строка						  - Путь к файлу лога
//
Функция ПолучитьИмяФайлаЛога(КаталогЛогирования, МаксРазмерФайла)
	
	ДатаФайла = Формат(ТекущаяДата(), "ДФ=ггггММдд");
	
	ФайлыЛога = НайтиФайлы(КаталогЛогирования, ДатаФайла + "*.log", Ложь);
	
	Если ФайлыЛога.Количество() = 0 Тогда
		ИмяФайла = ДатаФайла + "_1.log";
	Иначе
		МаксНомерФайла = 1;
		Для Каждого ТекФайл из ФайлыЛога Цикл
			МаксНомерФайла = Макс(МаксНомерФайла, Число(Сред(ТекФайл.ИмяБезРасширения, 10)));
		КонецЦикла;
		
		ИмяФайла = ДатаФайла + "_" + Формат(МаксНомерФайла) + ".log";
		
		ТекФайл = Новый Файл(КаталогЛогирования + "\" + ИмяФайла);
		
		Если ТекФайл.Размер() >= МаксРазмерФайла И МаксРазмерФайла > 0 Тогда
			ИмяФайла = ДатаФайла + "_" + Формат(МаксНомерФайла + 1) + ".log";
		КонецЕсли;
	КонецЕсли;	

	Возврат КаталогЛогирования + "\" + ИмяФайла;
	
КонецФункции // ПолучитьИмяФайлаЛога()

#КонецОбласти
