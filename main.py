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
def menu():
    while repeat:
            op=input("""\nSeleccione la actividad que desea realizar
        1. Ejecutar tareas pasivas
        2. Ejecutar tareas activas (REQUIERE AUTORIZACIÓN)
        3. Salir

        Ingrese una opción: """)

            if op=='1':
                print("\nRealizar atividades pasivas")
                repetir(repeat)
            
            elif op=='2':
                actActivas(host)
                repetir(repeat)
                
            elif op=='3':
                logging.warning(f"El usuario {usuario} salió del script.")
                print("Saliendo...")
                sys.exit()
            else:
                print("Opción no válida.")

#Control while
def repetir(r):
    print("\n¿Desea volver al menú?")
    r=input("y/n :").lower()
    if r.strip() =="y":
        r=True
    else:
        r=False
        print("Saliendo...")
        logging.warning(f"El usuario {usuario} salió del script.")
        sys.exit()

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




usuario=obtencion_usr()
verificador=aviso("""Este script realiza actividades de recolección de información y escaneo limitado de puertos al host scanme.nmap.org.
Queda terminantemente prohibida la explotación, modificación de servicios o exfiltración de datos.
Es necesario contar con autorización firmada del propietario del dominio para continuar.
De no tenerlo y continuar habrá repercusiones legales.""")

if verificador == "Aceptar":
    repeat=True
    logging.warning(f"El usuario {usuario} accedió al script")
    menu()    

else:
    logging.warning(f"El usuario {usuario} ejecutó el script pero salió.")
    sys.exit()



print("Esto nunca debería imprimirse")
