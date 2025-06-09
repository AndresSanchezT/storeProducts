use DBCARRITO
go

--RESETEO DE INDENTITY
DBCC CHECKIDENT ('dbo.CATEGORIA', RESEED, 4)

SELECT name, seed_value, increment_value
FROM sys.identity_columns
WHERE OBJECT_NAME(object_id) = 'CATEGORIA'


select * from dbo.USUARIO


---------------------PROCEDIMIENTOS PARA TABLA CATEGORIA--------------

create proc sp_RegistrarCategoria(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin 
	set @Resultado = 0
	if not exists (select * from CATEGORIA where Descripcion = @Descripcion)
	begin 
		insert into CATEGORIA(Descripcion,Activo) values
		(@Descripcion,@Activo)
		set @Resultado = SCOPE_IDENTITY()
	end
	else 
		set @Mensaje = 'La categoria ya existe'
end


create proc sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin 
	set @Resultado = 0
	if not exists (select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin

		update top(1) CATEGORIA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria
		set @Resultado = 1
	end
	else
		set @Mensaje = 'La categoria ya existe'
end


create proc sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin 
	set @Resultado = 0
	if not exists (select * from PRODUCTO p 
	inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
	where p.IdCategoria = @IdCategoria)
	begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
		set @Resultado = 1
	end
	else
		set @Mensaje = 'La categoria se encuentra relacionada a un producto'
end

