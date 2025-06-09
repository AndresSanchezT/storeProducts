use DBCARRITO
go


create proc sp_ReporteVentas(
	@fechainicio varchar(10),
	@fechafin varchar(10),
	@idtransaccion varchar(50)
)
as 
begin
	set dateformat dmy;

select convert(char(10),v.FechaVenta,103)[FechaVenta],CONCAT(c.Nombres,' ',c.Apellidos)[Cliente],
p.Nombre[Producto],p.Precio,dv.Cantidad,dv.Total,v.IdTransaccion
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
inner join VENTA v on  v.IdVenta = dv.IdVenta
inner join CLIENTE c on c.IdCliente = v.IdCliente
where CONVERT(date,v.FechaVenta) between @fechainicio and @fechafin

and v.IdTransaccion = iif(@idtransaccion = '', v.IdTransaccion ,@idtransaccion)

end

select * FROM VENTA
select * FROM USUARIO



exec sp_ReporteVentas '10-02-24','10-03-25',''