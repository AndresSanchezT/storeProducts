use DBCarrito
go

create proc sp_RegistrarUsuario
(	@Nombres varchar(100),
	@Apellidos varchar(100),
	@Correo varchar(100),
	@Clave varchar(100),
	@Activo bit,
	@Mensaje varchar(50) output,
	@Resultado int output	
)as
begin 
	set @Resultado = 0 
	if not exists(select * from USUARIO where Correo=@Correo)
	begin
		insert into USUARIO(Nombres,Apellidos,Correo,Clave,Activo)
			   values (@Nombres,@Apellidos,@Correo,@Clave,@Activo)
			   set @Resultado = SCOPE_IDENTITY()
    end
	else
		set @Mensaje = 'El Correo del usuario ya existe'
end

create proc sp_EditarUsuario
(
	@IdUsuario int,
	@Nombres varchar(100),
	@Apellidos varchar(100),
	@Correo varchar(100),
	@Activo bit,
	@Mensaje varchar(500) output,
	@Resultado bit output
)
as
begin
	set @Resultado=0
	if not exists(select*from USUARIO where Correo = @Correo and IdUsuario != @IdUsuario)
	begin 
		update top(1) USUARIO set
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario
		set @Resultado = 1
	end
	else 
	set @Mensaje = 'El correo del usuario ya existe'
end;
