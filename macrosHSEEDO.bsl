
ПараметрыДействийСхемы = Справочники.СхемыКомплексныхПроцессов.ПараметрыДействийСхемы(Процесс.Схема);

Запрос = Новый Запрос;

Запрос.Текст = 

"ВЫБРАТЬ
|	ВЫРАЗИТЬ(&Документ КАК Справочник.ВнутренниеДокументы) КАК Документ
|ПОМЕСТИТЬ ВременнаяТаблица
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВЫБОР
|		КОГДА ВизыСогласования.Исполнитель = НЕОПРЕДЕЛЕНО
|			ТОГДА ВизыСогласования.РольИсполнителя
|		ИНАЧЕ ВизыСогласования.Исполнитель
|	КОНЕЦ КАК Исполнитель,
|	ВизыСогласования.СрокИсполнения КАК СрокИсполнения,
|	ВизыСогласования.РезультатСогласования КАК РезультатСогласования,  
|	ВизыСогласования.РольИсполнителя КАК РольИсполнителя,
|	ВременнаяТаблица.Документ КАК Документ,
|	ВизыСогласования.вшэПорядокСогласования КАК ПорядокСогласования,
|	ВизыСогласования.ПомещенаВИсторию КАК ПомещенаВИсторию
|ИЗ
|	ВременнаяТаблица КАК ВременнаяТаблица
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВизыСогласования КАК ВизыСогласования
|		ПО ВременнаяТаблица.Документ = ВизыСогласования.Документ
|			И (ВизыСогласования.РезультатСогласования = ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.ПустаяССылка))
|			И (ВизыСогласования.вшэВизирование)
|			И (НЕ ВизыСогласования.ПометкаУдаления)
|			И (НЕ ВизыСогласования.ПомещенаВИсторию)
|
|УПОРЯДОЧИТЬ ПО
|	ВизыСогласования.Порядок";

Запрос.УстановитьПараметр("Документ", Процесс.Предметы[0].Предмет); 
РезультатЗапроса = Запрос.Выполнить();                              
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();                

СогласованиеТест = ПараметрыДействийСхемы.Найти("Действие3").ШаблонПроцесса.ПолучитьОбъект(); 

СогласованиеТест.Исполнители.Очистить(); 

Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	
	НоваяСтрока = СогласованиеТест.Исполнители.Добавить();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока,ВыборкаДетальныеЗаписи);
	
КонецЦикла;    

СогласованиеТест.ВариантСогласования = Процесс.Предметы[0].Предмет.вшэВариантВизирования;

СогласованиеТест.ОбменДанными.Загрузка = Истина;

СогласованиеТест.Записать();
