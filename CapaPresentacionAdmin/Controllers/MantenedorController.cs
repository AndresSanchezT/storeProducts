using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CapaEntidad;
using CapaNegocio;
using Newtonsoft.Json;

//para poder leer las variables del archivo web.config
using System.Configuration;
using System.IO;

namespace CapaPresentacionAdmin.Controllers
{
    [Authorize]
    public class MantenedorController : Controller
    {
        // GET: Mantenedor
        public ActionResult Categoria()
        {
            return View();
        }
        public ActionResult Marca()
        {
            return View();
        }
        public ActionResult Producto()
        {
            return View();
        }




        // ++++++++++++++++++++++++++++ CATEGORIA ++++++++++++++++++++++++++++++

        #region CATEGORIA
        [HttpGet]
        public JsonResult ListarCategorias()
        {
            List<Categoria> oLista = new List<Categoria>();

            oLista = new CN_Categoria().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult GuardarCategoria(Categoria obj)
        {
            object resultado;

            string mensaje = string.Empty;

            if (obj.IdCategoria == 0)
            {
                resultado = new CN_Categoria().Registrar(obj, out mensaje);
            }
            else
            {
                resultado = new CN_Categoria().Editar(obj, out mensaje);
            }

            return Json(new { resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult EliminarCategoria(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Categoria().Eliminar(id, out mensaje);

            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        // ++++++++++++++++++++++++++++ MARCA ++++++++++++++++++++++++++++++

        #region MARCA
        [HttpGet]
        public JsonResult ListarMarca()
        {
            List<Marca> oLista = new List<Marca>();

            oLista = new CN_Marca().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult GuardarMarca(Marca obj)
        {
            object resultado;

            string mensaje = string.Empty;

            if (obj.IdMarca == 0)
            {
                resultado = new CN_Marca().Registrar(obj, out mensaje);
            }
            else
            {
                resultado = new CN_Marca().Editar(obj, out mensaje);
            }

            return Json(new { resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult EliminarMarca(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Marca().Eliminar(id, out mensaje);

            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion


        // ++++++++++++++++++++++++++++ PRODUCTO ++++++++++++++++++++++++++++++

        #region PRODUCTO
        [HttpGet]
        public JsonResult listarProducto()
        {
            List<Producto> oLista = new List<Producto>();

            oLista = new CN_Producto().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult GuardarProducto(string obj,HttpPostedFileBase archivoImagen)
        {
            string mensaje = string.Empty;
            bool operacion_exitosa = true;
            bool guardar_imagen_exito = true;

            Producto oProducto = new Producto();
            oProducto = JsonConvert.DeserializeObject<Producto>(obj);

            decimal precio;

            if (decimal.TryParse(oProducto.PrecioTexto,NumberStyles.AllowDecimalPoint, new CultureInfo("es-PE"), out precio))
            {
                oProducto.Precio = precio;
            }else
            {
                return Json(new { operacionExitosa = false, mensaje = "El formato del precio debe ser ##.##" },JsonRequestBehavior.AllowGet);
            }



            if (oProducto.IdProducto == 0)
            {
                int idProductoGenerado = new CN_Producto().Registrar(oProducto, out mensaje);

                if(idProductoGenerado != 0)
                {
                    oProducto.IdProducto = idProductoGenerado;
                } else
                {
                    operacion_exitosa = false;
                }
            }
            else
            {
                operacion_exitosa = new CN_Producto().Editar(oProducto, out mensaje);
            }

            if(operacion_exitosa)
            {
                if(archivoImagen != null)
                {
                    string ruta_guardar = ConfigurationManager.AppSettings["ServidorFotos"];
                    string extension = Path.GetExtension(archivoImagen.FileName);
                    string nombre_imagen = string.Concat(oProducto.IdProducto.ToString(),extension);

                    try
                    {
                        archivoImagen.SaveAs(Path.Combine(ruta_guardar, nombre_imagen));
                    }
                    catch(Exception ex)
                    {
                        string msg = ex.Message;
                        guardar_imagen_exito = false;
                    }

                    if(guardar_imagen_exito )
                    {
                        oProducto.RutaImagen = ruta_guardar;
                        oProducto.NombreImagen = nombre_imagen;
                        bool rspta = new CN_Producto().GuardarDatosImagen(oProducto,out mensaje);
                    }else
                    {
                        mensaje = "Se guardó producto pero hubo problemas con la imagen";
                    }
                }
            }



            return Json(new { operacionExitosa = operacion_exitosa,idGenerado = oProducto.IdProducto, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost] 
        public JsonResult ImagenProducto(int id)
        {
            bool conversion;
            Producto oproducto = new CN_Producto().Listar().Where(p => p.IdProducto == id).FirstOrDefault();

            string textoBase64 = CN_Recursos.ConvertirBase64(Path.Combine(oproducto.RutaImagen,oproducto.NombreImagen),out conversion);

            return Json(new
            {
                conversion = conversion,
                textoBase64 = textoBase64,
                extension = Path.GetExtension(oproducto.NombreImagen)  
            },
            JsonRequestBehavior.AllowGet);
        }




        [HttpPost]
        public JsonResult EliminarProducto(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Producto().Eliminar(id, out mensaje);

            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion

    }
}