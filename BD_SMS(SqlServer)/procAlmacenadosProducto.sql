use DBCARRITO

select * from USUARIO

select * from PRODUCTO

create proc sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),	
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(select * from PRODUCTO where Nombre = @Nombre)
	begin 
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo)values
		(@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo)
		set @Resultado = SCOPE_IDENTITY()
	end
	else 
		set @Mensaje = 'El producto ya existe'
end 

--//////////////////////////////////////////////////////////////////////////////--
create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(select * from PRODUCTO where Nombre = @Nombre and IdProducto != @IdProducto)
	begin 
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio, 
		Stock = @Stock,
		Activo = @Activo
		where IdProducto = @IdProducto

		set @Resultado = 1
	end
	else 
		set @Mensaje = 'El producto no existe'
end 

--//////////////////////////////////***********************************
 create proc(
 @IdProducto int,
 @Mensaje varchar(500) output,
 @Resultado bit output
 )
 as
 begin 
	set @Resultado = 0
	if not exists(select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin 
		delete top(1) from PRODUCTO where IdProducto = @IdProducto
		set @Resultado = 1
	end
	else	
		set @Mensaje = 'El producto se encuentra relacionado a una venta'
end


--SELECION ESPECIFICA DE TABLA DE PRODUCTOS
use DBCARRITO 

select p.IdProducto,p.Nombre,p.Descripcion,
m.IdMarca,m.Descripcion[DesMarca],
c.IdCategoria,c.Descripcion[DesCategoria],
p.Precio,p.Stock,p.RutaImagen,p.NombreImagen,p.Activo
from PRODUCTO P
inner join MARCA m on m.IdMarca = p.IdMarca
inner join CATEGORIA c on c.IdCategoria = p.IdCategoria



select * from MARCA
select * from CATEGORIA

SELECT p.IdProducto, p.Nombre, p.Descripcion, 
       m.IdMarca, m.Descripcion AS DesMarca, 
       c.IdCategoria, c.Descripcion AS DesCategoria, 
       p.Precio, p.Stock, p.RutaImagen, p.NombreImagen, p.Activo
FROM PRODUCTO P
INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria;

select * from CLIENTE

--CONSULTA
select count(*) from CARRITO where IdCliente = 1

create proc sp_ExisteCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as 
begin 
	if exists(select * from CARRITO where IdCliente=@IdCliente and IdProducto=@IdProducto)
		set @Resultado = 1
    else
		set @Resultado = 0
end


----------------------------------------------------
create proc sp_OperacionCarrito(
@IdCliente int,
@IdProducto int,
@Sumar bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	set @Mensaje = ''	

	declare @existecarrito bit = iif(exists(select * from carrito where IdCliente = @IdCliente and idproducto = @IdProducto),1,0)
	declare @stockproducto int = (select stock from PRODUCTO where IdProducto = @IdProducto)

	begin try
		begin transaction operacion
		if(@Sumar = 1)
		begin
				if(@stockproducto>0)
				begin
					if(@existecarrito = 1)
						update CARRITO set Cantidad = Cantidad + 1 where IdCliente = @IdCliente and IdProducto = @IdProducto
					else
						insert into CARRITO(IdCliente,IdProducto,Cantidad) values(@IdCliente,@IdProducto,1)
						update PRODUCTO set Stock  = Stock - 1 where IdProducto = @IdProducto
				end
				else
				begin 
					set @Resultado = 0
					set @Mensaje = 'El producto no cuenta con stock disponible'
				end
		end
		else
			begin
				update CARRITO set Cantidad = Cantidad - 1 where IdCliente = @IdCliente and IdProducto = @IdProducto
				update PRODUCTO set Stock = Stock + 1 where IdProducto = @IdProducto
			end

		commit transaction operacion

		end try
		begin catch
			set @Resultado = 0
			set @Mensaje = ERROR_MESSAGE()
			rollback transaction operacion
		end catch
end

select * from PRODUCTO		
SELECT * FROM CATEGORIA
SELECT* FROM MARCA
SELECT * FROM CLIENTE
SELECT * FROM CARRITO
------------------------------


create function fn_obtenerCarritoCliente(
@idcliente int
)
returns table
as
return(
	select p.IdProducto,m.Descripcion[DesMarca],p.Nombre,p.Precio,c.Cantidad,p.RutaImagen,p.NombreImagen
	from carrito c
	inner join PRODUCTO p on p.IdProducto = c.IdProducto
	inner join MARCA m on m.IdMarca = p.IdMarca
	where c.IdCliente = @idcliente
)

select * from fn_obtenerCarritoCliente(2)

--------------------------------------------
use DBCARRITO 
create proc sp_EliminarCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	declare @cantidadproducto int = (select cantidad from CARRITO where IdCliente=@IdCliente and IdProducto=@IdProducto)
	
	begin try
		begin transaction operacion
		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top (1) from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto
		commit transaction operacion
	end try
	begin catch
		set @Resultado = 0
		rollback transaction operacion
	end catch
end
-------------------------------------
select * from DEPARTAMENTO
select * from PROVINCIA where IdDepartamento = '01'
select * from DISTRITO where IdProvincia = @idprovincia and IdDepartamento = @iddepartamento


select * from PRODUCTO	
SELECT * FROM CLIENTE
update PRODUCTO 
set Stock = 10


   

