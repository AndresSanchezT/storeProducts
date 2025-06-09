
select *from cliente

create type [dbo].[EDetalle_Venta] as table(
	[IdProducto] int null,
	[Cantidad] int null,
	[Total] decimal(18,2) null
)

create procedure usp_RegistrarVenta(
@IdCliente int,
@TotalProducto int,
@MontoTotal decimal(18,2),
@Contacto varchar(100),
@IdDistrito varchar(6),
@Telefono varchar(10),
@Direccion varchar(100),
@IdTransaccion varchar(50),
@DetalleVenta [EDetalle_Venta] readonly,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''
		
		begin transaction registro
		insert into VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,IdDistrito,Telefono,Direccion,IdTransaccion)
		values(@IdCliente,@TotalProducto,@MontoTotal,@Contacto,@IdDistrito,@Telefono,@Direccion,@IdTransaccion)

		set @idventa = SCOPE_IDENTITY()

		insert into DETALLE_VENTA(IdVenta,IdProducto,Cantidad,Total)
		select @idventa,IdProducto,Cantidad,Total from @DetalleVenta

		delete from CARRITO where IdCliente = @IdCliente
		commit transaction registro
	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end

-----------
select * from VENTA

select *from DETALLE_VENTA