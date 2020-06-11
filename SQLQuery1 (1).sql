use ViajesEsp

Create table Dependencia (Codigo_d int PRIMARY KEY, Nombre varchar(100));

insert Dependencia values (1, 'Agencia 1'), (2, 'Agencia 2');

Create table Tripulacion(Codigo_t int PRIMARY KEY, Nombre varchar(50), Categoría char(1), Antigüedad int, 
                         Codigo_d int FOREIGN KEY (Codigo_d) REFERENCES Dependencia(Codigo_d), 
						 Estado char(1), Cédula char(12) UNIQUE);

Insert Tripulacion values (1, 'James', 'A', 2, 1, 'A', '102220333'), (2, 'Raquel', 'A', 5, 2, 'A', '401110333'),(3, 'Valery', 'B', 0, 1, 'I', '301230333')

Create table Planeta (Cod_p int PRIMARY KEY, Nombre_p varchar(30), Coordenadas_p varchar(50) null);

Insert Planeta values (1, 'Planeta A', 'r=1.25, ?=100°'), (2, 'Planeta B', 'r=1.25, ?=150°'), (3, 'Planeta C', 'r=1.25, ?=150°')

Create table Visita(Codigo_t int, Cod_p int, Fecha_visita date, Tiempo int,   -- tiempo viene en horas
       PRIMARY KEY (Codigo_t, Cod_p, Fecha_visita), FOREIGN KEY (Codigo_t) REFERENCES Tripulacion(Codigo_t), 
	   FOREIGN KEY (Cod_p) REFERENCES Planeta(Cod_p));

insert Visita values (1,1, '20190202', 500), (1,2, '20191002', 200), (1,1, '202002220',155), (1,2, '20200421', 25)
                     (2,1, '20190315', 50), (2,1, '20191002', 75),
					 (3,1, '20190522', 50),  (3,1, '20190702', 75),  (3,1, '20200205', 30), (3,1, '20200315', 50),
                     (3,2, '20190802', 250), (3,2, '20200102', 80), (3,2, '20200502', 60),  (3,2, '20191102', 20) 

Create table Viajes_Tripulante(Codigo_t int, Cod_p int, Tiempo_total float, Num_visitas int, 
                  PRIMARY KEY (Codigo_t, Cod_p), FOREIGN KEY (Codigo_t) REFERENCES Tripulacion(Codigo_t), 
				  FOREIGN KEY (Cod_p) REFERENCES Planeta(Cod_p));

insert Viajes_Tripulante values (1, 1, 700, 2), (2, 1, 125,2),  (3,1, 205, 4), (3,2, 410, 4)


Create table Monto_Categoria (Categoría char(1) PRIMARY KEY, Monto_hora float);

insert Monto_Categoria values ('A', 250000), ('B', 300000), ('C', 500000)  -- es el monto pagado por hora

create table ReporteHonorarios (Código_t int, Cod_p int, Tiempo_total float, Nombre varchar(50), Cédula char(12), Monto_a_pagar float)


create procedure Proced_1

/*Defina un procedimiento almacenado para que todas las visitas de los tripulantes a algún planeta, 
siempre que correspondan a visitas de  un tiempo total mayor a 200 horas, sean registradas en la 
tabla ReporteHonorarios (Código_t, Cod_p, Tiempo_total, Nombre, Cédula, Monto_a_pagar).  
Para calcular el monto a pagar, codifique y llame (con exec)  al procedimiento RegistraHonorarios 
que recibe la cédula, tiempo_total, y retorna por parámetro el Monto_a_pagar,  para que lo grabe 
en ReporteHonorarios.  El monto de la hora está en la table Monto_Categoria.   
Con un print despliegue el nombre del astronauta y el monto del 3% retornado.*/
as begin

   declare @Codigo_t int, @Cod_p int, @Tiempo_total float, @cedula char(12), @Nombre varchar(50),
           @Monto_a_pagar float, @monto_char varchar(10)


		  
		   



   declare Viajes cursor for
   select Tiempo_total, Cedula from Viajes_Tripulante VT, Tripulación T
   where tiempo_total > 200 and VT.Codigo_t= T.Codigo_t

   open Viajes
   Fecth Viajes into  @tiempo_total, @Cedula

   while @@FETCH_STATUS=0 begin
      set @Monto_a_pagar = 0
      exec RegistraHonorarios @cedula, @tiempo_total, @cod_p, @Monto_a_pagar output,
	  set @monto_char= convert(char(10), @Monto_a_pagar)
      print 'Al astronauta '+@nombre+ ' se le pagará: '+@monto_char
      Fecth Viajes into @tiempo_total, @Cedula
   end
end


create procedure RegistraHonorarios  @cedula char(12), @tiempo_total float, @cod_p int, @Monto_a_pagar float output
as
begin
    declare @Monto_hora float, @codigo_t int, @Nombre varchar(50) 

    select @Monto_hora=Monto_hora, @codigo_t =Codigo_t,@Nombre=Nombre
	from Tripulacion, Monto_Categoria 
	where cedula = @cedula and Tripulacion.Categoria=Monto_Categoria.Categoria

	select @Monto_a_pagar= @Monto_hora * @tiempo_total
	insert ReporteHonorarios values (@Codigo_t, @Cod_p, @Tiempo_total, 
	                                   @Nombre, @cedula, @Monto_a_pagar)
end



  create procedure Quiz @codigoP int
as 
begin

	select Planeta.Nombre_p, Tripulacion.Nombre, Fecha_visita from Visita
	inner join Planeta on Planeta.Cod_p=Visita.Cod_p
	inner join Tripulacion on Tripulacion.Codigo_t=Visita.Codigo_t
	where Visita.Cod_p=@codigoP and Visita.Fecha_visita >= cast('1/1/2019' AS datetime);
end