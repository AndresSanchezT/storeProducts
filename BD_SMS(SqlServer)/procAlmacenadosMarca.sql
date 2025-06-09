use DBCARRITO
go

--RESETEO DE INDENTITY
DBCC CHECKIDENT ('dbo.MARCA', RESEED, 4)

SELECT name, seed_value, increment_value
FROM sys.identity_columns
WHERE OBJECT_NAME(object_id) = 'MARCA'

select * from MARCA
      


---------------------PROCEDIMIENTOS PARA TABLA MARCA--------------

create proc sp_RegistrarMarca(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output     
)
as
begin 
	set @Resultado = 0
	if not exists (select * from MARCA where Descripcion = @Descripcion)
	begin 
		insert into MARCA(Descripcion,Activo) values
		(@Descripcion,@Activo)
		set @Resultado = SCOPE_IDENTITY()
	end
	else 
		set @Mensaje = 'La Marca ya existe'
end


create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin 
	set @Resultado = 0
	if not exists (select * from MARCA where Descripcion = @Descripcion and IdMarca != @IdMarca)
	begin
		update top(1) MARCA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca
		set @Resultado = 1
	end
	else
		set @Mensaje = 'La Marca ya existe'
end


create proc sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin 
	set @Resultado = 0
	if not exists (select * from PRODUCTO p 
	inner join MARCA m on m.IdMarca = p.IdMarca
	where p.IdMarca = @IdMarca)
	begin
		delete top(1) from MARCA where IdMarca = @IdMarca
		set @Resultado = 1
	end
	else
		set @Mensaje = 'La Marca se encuentra relacionada a un producto'
end
