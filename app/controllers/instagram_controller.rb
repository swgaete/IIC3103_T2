require 'net/http'
require 'json'
require 'instagram'

class InstagramController < ApplicationController

  skip_before_filter :verify_authenticity_token  

  def searchTag
    tag = params.has_key?(:tag) ? params[:tag] : nil
    access_token = params.has_key?(:access_token) ? params[:access_token] : nil

    if tag.nil? or access_token.nil?
      render json: {'error' => 'Missing parameter'}, root: false, status: :bad_request
    else
      client = Instagram.client(:access_token => access_token)
      response = client.tag_recent_media(tag)
      result = formatResponse(response)
      render json: result, root: false
    end
  end


  def formatResponse(response)
    result= { 'metadata' => {},
              'posts' => [],
              'version' => ENV['version']
            }

    count = response.length
    metadata = {:total => count}
    result['metadata'] = metadata

    response.each do |post|
      result['posts'] << {
        'tags' => post.tags,
        'username' => post.user.username,
        'likes' => post.likes.count,
        'url' => post.images.standard_resolution.url,
        'caption' => post.caption.text
      }
    end

    return result
  end
end
