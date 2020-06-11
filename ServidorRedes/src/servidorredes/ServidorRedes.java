/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servidorredes;

import Data.connection;
import Domain.Usuarios;
import GUI.Ventana;
import GUI.VentanaPrincipal;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.*;
import java.net.*;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import jdk.nashorn.internal.runtime.ListAdapter;
import java.net.*;
import java.io.*;
import java.util.*;
/**
 *
 * @author Pablo
 */
public class ServidorRedes {
    
   static ArrayList<Usuarios> lista = new ArrayList<>(100);

    /**
     * @param args the command line arguments
     */
   
   
 
       public static void iniciarServidor() throws IOException 
       {
               ServerSocket servidor  = new ServerSocket( 4400 );

          System.out.println( "Esperando recepcion de archivos..." ); 
          while( true )
          {
 
            try
            {
               // Creamos el socket que atendera el servidor
               Socket cliente = servidor.accept(); 
 
               // Creamos flujo de entrada para leer los datos que envia el cliente 
               DataInputStream dis = new DataInputStream( cliente.getInputStream() );
        
               // Obtenemos el nombre del archivo
               String nombreArchivo = dis.readUTF().toString(); 
 
               // Obtenemos el tamaño del archivo
               int tam = dis.readInt(); 
 
               System.out.println( "Recibiendo archivo "+nombreArchivo );
        
               // Creamos flujo de salida, este flujo nos sirve para 
               // indicar donde guardaremos el archivo
               FileOutputStream fos = new FileOutputStream( nombreArchivo );
               BufferedOutputStream out = new BufferedOutputStream( fos );
               BufferedInputStream in = new BufferedInputStream( cliente.getInputStream() );
 
               // Creamos el array de bytes para leer los datos del archivo
               byte[] buffer = new byte[ tam ];
 
               // Obtenemos el archivo mediante la lectura de bytes enviados
               for( int i = 0; i < buffer.length; i++ )
               {
                  buffer[ i ] = ( byte )in.read( ); 
               }
 
               // Escribimos el archivo 
               out.write( buffer ); 
 
               // Cerramos flujos
               out.flush(); 
               in.close();
               out.close(); 
               //cliente.close();
 
               System.out.println( "Archivo Recibido "+nombreArchivo );
        
           }
           catch( Exception e )
           {
              System.out.println( "Recibir: "+e.toString() ); 
           }
         } 
       }
         

    public static void main(String[] args) throws IOException, SQLException, ClassNotFoundException {
          //Ventana ventana = new Ventana();
        VentanaPrincipal v =new VentanaPrincipal();
        v.setVisible(true);
  iniciarServidor();        
    }

    
}
