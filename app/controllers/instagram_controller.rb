 require 'json'
require 'instagram'

class InstagramController < ApplicationController

  skip_before_filter :verify_authenticity_token  

  def searchTag
    #definimos los parametros del post
    tag = params.has_key?(:tag) ? params[:tag] : nil
    access_token = params.has_key?(:access_token) ? params[:access_token] : nil
    #verificamos que los parámetros estén 
    if tag.nil? or access_token.nil?
      #si los parametros no estan tiramos error 400
      render json: {'error' => 'Missing parameter'}, root: false, status: :bad_request
    else
      #si los parametros están correctos usamos la api de instagram
      client = Instagram.client(:access_token => access_token)
      response = client.tag_recent_media(tag)
      #formatemos la respuesta
      result = format(response)
      #mostramos la respuesta
      render json: result, root: false
    end
  end


  def format(response)
    #definimos el formato de los resultados
    result= { 'metadata' => {},
              'posts' => [],
              'version' => ENV['version']
            }
    #formateamos el contenido de los metadatos
    count = response.length
    metadata = {:total => count}
    result['metadata'] = metadata
    #formateamos el contenido de los post
    response.each do |post|
      result['posts'] << {
        'tags' => post.tags,
        'username' => post.user.username,
        'likes' => post.likes.count,
        'url' => post.images.standard_resolution.url,
        'caption' => post.caption.text
      }
    end
    #devolvermos la respuesta formateada como se pide
    return result
  end
end
