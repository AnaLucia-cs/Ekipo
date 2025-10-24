import subprocess
import sys
import logging
import pyautogui as py
import nmap

#VARIABLES
host="scanme.nmap.org"
AUTHORIZED = False
results_path="analisis_Host.txt"

#Configuración logging
logging.basicConfig(
    filename="registroEscaneos.log",
    encoding="utf-8",
    level=logging.DEBUG,
    format="%(asctime)s - %(levelname)s - %(message)s"
    )

#Obtiene el usuario
def obtencion_usr():
    obtener_usuario = subprocess.run(["wsl", "whoami"], capture_output=True, text=True)
    return obtener_usuario.stdout.strip()
    
#Muestra avisos
def aviso(mensaje:str):
    verificador = py.confirm(mensaje, buttons=["Aceptar", "Salir"])
    return verificador

#Invoca al menú
def menu(repeat, usuario):
    while repeat:
        op=input("""\nSeleccione la actividad que desea realizar
    1. Ejecutar tareas pasivas
    2. Ejecutar tareas activas (REQUIERE AUTORIZACIÓN)
    3. Salir

    Ingrese una opción: """)
        if op=='1':
            actPasivas()
            repetir(repeat,usuario)
        
        elif op=='2':
            actActivas(host)
            repetir(repeat,usuario)
            
        elif op=='3':
           salir(usuario)
        else:
            print("Opción no válida.")

#Control while del menú
def repetir(r,usr):
    print("\n¿Desea volver al menú?")
    r=input("y/n :").lower()
    if r.strip() == "y":
        r=True
    else:
        r=False
        salir(usr)     

#Invoca tareas activas
def actActivas(host):

    print(f"Verificando la conexión al host {host}...")
    try:
        hacer_ping = subprocess.run(["wsl", "ping", "-c", "2", host], capture_output=True, text=True)

        if (hacer_ping.returncode !=0 ):
            print(f"El host {host} no pudo ser accedido.")
            sys.exit(hacer_ping.returncode)  
    except:
        print(f"Fallo al realizar ping al host {host}")
        sys.exit(1)

    print("Conexión exitosa")
    try:
        #Empezar el escaneo de puertos del host
        print("Escaneando puertos...")
        cuidar_puertos="21,22,23,25,3306,54,8080,8443,80,443"
        
        escanear = subprocess.run(["wsl", "nmap","-sV", "-p",cuidar_puertos,"--script","http-headers,http-title,ssl-cert", host], capture_output=True, text=True)
        print(escanear.stdout)

        with open(results_path, "w") as external_file:
            print(escanear.stdout, file=external_file)
            external_file.close()
            
    # print(escanear.returncode)
        print("Escaneo terminado.")

    except Exception as e:
        print("Ocurrió un error en el escaneo")

#Invoca tareas pasivas
def actPasivas():
    print("aqui tu chamba Ana")

#Salir script y registrar en log
def salir(usr):
    print("Saliendo...")
    logging.warning(f"El usuario {usr} salió del script.")
    sys.exit()

#Control principal del flujo
def main():
    usuario=obtencion_usr()
    verificador=aviso("""Este script realiza actividades de recolección de información y escaneo limitado de puertos al host scanme.nmap.org.
    Queda terminantemente prohibida la explotación, modificación de servicios o exfiltración de datos.
    Es necesario contar con autorización firmada del propietario del dominio para continuar.
    De no tenerlo y continuar habrá repercusiones legales.""")

    logging.warning(f"El usuario {usuario} accedió al script")

    if verificador == "Aceptar":
        repeat=True
        menu(repeat, usuario) 

    else:
        salir(usuario)

#Invoca al módulo principal
main()