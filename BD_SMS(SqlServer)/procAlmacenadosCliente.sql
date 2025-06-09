use DBCARRITO
go

select * from usuario
select * from CLIENTE

create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500)output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(select * from CLIENTE where Correo = @Correo)
	begin
		insert into CLIENTE(Nombres,Apellidos,Correo,Clave,Reestablecer) values
		(@Nombres,@Apellidos,@Correo,@Clave,0)
		set @Resultado = SCOPE_IDENTITY()
	end
	else 
	set @Mensaje = 'El correo del usuario ya existe'
end



declare @idcategoria int = 0

select distinct m.IdMarca,m.Descripcion from PRODUCTO p
inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
inner join MARCA m on m.IdMarca = p.IdMarca and m.Activo = 1
where c.IdCategoria = iif( @idcategoria = 0,c.IdCategoria,@idcategoria)

select * from PRODUCTO
select * from MARCA
select * from CATEGORIA


