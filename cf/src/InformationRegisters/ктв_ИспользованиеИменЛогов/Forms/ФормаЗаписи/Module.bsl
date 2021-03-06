
// Процедура - обработчик события ПриСозданииНаСервере
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяЛога = Запись.ИмяЛога;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПередЗаписью
//
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Запись.ИмяЛога = ИмяЛога;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события НачалоВыбора поля ИмяЛога
//
&НаКлиенте
Процедура ИмяЛогаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Исключения = ПолучитьСписокИсключенийИменЛогов(Запись.СпособЛогирования, Запись.ИмяЛога);
	
	ВремСписокВыбора = Новый СписокЗначений();
	ВремСписокВыбора.ЗагрузитьЗначения(ктв_ЛогированиеВызовСервера.ПолучитьИменаЛогов(Исключения));
	
	ОбработкаВыбораИзСписка = Новый ОписаниеОповещения("ИмяЛогаНачалоВыбораЗавершение", ЭтаФорма);
	
	ПоказатьВыборИзСписка(ОбработкаВыбораИзСписка, ВремСписокВыбора, Элементы.ИмяЛога);
	
КонецПроцедуры // ИмяЛогаНачалоВыбора()

// Процедура - продолжение обработчика события НачалоВыбора поля ИмяЛога
//
&НаКлиенте
Процедура ИмяЛогаНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЛога = ВыбранныйЭлемент.Значение;
	
КонецПроцедуры // ИмяЛогаНачалоВыбораЗавершение()

// Функция - получает список имен логов недоступных для выбора
//
// Параметры:
//	СпособЛогирования		- СправочникСсылка.			- способ логирования, для которого получаем исключения
//							  ктв_СпособыЛогирования
//	ТекущееЗначение			- Строка					- имя лога, которое не нужно исключать
//
// Возвращаемое значение:
//	Массив (Строка)			- массив исключаемых имен логов
//
&НаСервереБезКонтекста
Функция ПолучитьСписокИсключенийИменЛогов(СпособЛогирования, ТекущееЗначение = Неопределено)

	НаборЗаписей = РегистрыСведений.ктв_ИспользованиеИменЛогов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.СпособЛогирования.Установить(СпособЛогирования);
	НаборЗаписей.Прочитать();
	
	Исключения = Новый Массив();
	
	Для Каждого ТекЗапись Из НаборЗаписей Цикл
		Если ПустаяСтрока(ТекЗапись.ИмяЛога) Тогда
			Продолжить;
		КонецЕсли;
		Если ТекущееЗначение = ТекЗапись.ИмяЛога Тогда
			Продолжить;
		КонецЕсли;
		Исключения.Добавить(ТекЗапись.ИмяЛога);
	КонецЦикла;
	
	Возврат Исключения;
	
КонецФункции // ПолучитьСписокИсключенийИменЛогов()
