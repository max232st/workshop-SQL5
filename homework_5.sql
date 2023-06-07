CREATE TABLE cars (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	model VARCHAR(55),
    cost INT);

INSERT INTO cars (id, model, cost) VALUES (1, 'Audi', 52642);
INSERT INTO cars (id, model, cost) VALUES (2, 'Mercedes', 57127);
INSERT INTO cars (id, model, cost) VALUES (3, 'Skoda', 9000);
INSERT INTO cars (id, model, cost) VALUES (4, 'Volvo', 29000);
INSERT INTO cars (id, model, cost) VALUES (5, 'Bentley', 35000);
INSERT INTO cars (id, model, cost) VALUES (6, 'Citroen', 21000);
INSERT INTO cars (id, model, cost) VALUES (7, 'Hummer', 41400);
INSERT INTO cars (id, model, cost) VALUES (8, 'Volkswagen', 21600);

SELECT * FROM cars;
    
-- Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов

CREATE VIEW cheap_cars AS
SELECT *
FROM cars
WHERE cost < 25000;

SELECT * FROM cheap_cars;

/* 
Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
*/

ALTER VIEW cheap_cars AS
SELECT *
FROM cars
WHERE cost < 30000;

SELECT * FROM cheap_cars;

-- Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”

CREATE VIEW skoda_audi AS
SELECT *
FROM cars
WHERE model IN ('Skoda', 'Audi');

SELECT * 
FROM skoda_audi;

/*
Добавьте новый столбец под названием «время до следующей станции». 
Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, 
но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD . 
Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить 
результат. В этом случае функция сравнивает значения в столбце «время» для станции со 
станцией сразу после нее.
*/

CREATE TABLE stations
(
train_id INT NOT NULL,
station varchar(20) NOT NULL,
station_time TIME NOT NULL
);
INSERT stations(train_id, station, station_time)
VALUES (110, "SanFrancisco", "10:00:00"),
(110, "Redwood Sity", "10:54:00"),
(110, "Palo Alto", "11:02:00"),
(110, "San Jose", "12:35:00"),
(120, "SanFrancisco", "11:00:00"),
(120, "Palo Alto", "12:49:00"),
(120, "San Jose", "13:30:00");

SELECT * FROM stations;

ALTER TABLE stations
ADD COLUMN time_to_next_station TIME;

UPDATE stations s
JOIN (
    SELECT train_id, station, station_time, 
	LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time) 
    AS next_station_time
    FROM stations) t 
    ON s.train_id = t.train_id AND s.station = t.station 
    AND s.station_time = t.station_time
	SET s.time_to_next_station = TIMEDIFF(t.next_station_time, s.station_time);

SELECT * FROM stations;