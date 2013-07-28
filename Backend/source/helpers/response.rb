#!/usr/bin/env ruby

module ResponseHelpers
  def response bSuccessful, oResponse = null
    if (true === bSuccessful)
      return (null == oResponse) ? 
      	{ :screquest => { :successful => true }} : 
      	{ :screquest => { :successful => true, :response => oReponse }}
    else
      return (null == oResponse) ?
        { :screquest => { :successful => false, :error => { :error_id => oResponse.id, :error_msg => oResponse.msg }}} :
        { :screquest => { :successful => false, :error => { :error_id => -32000, :error_msg => "Unknown Error" }}}
    end
  end
end