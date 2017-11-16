# (1) all the description:
#   CommonMark(http://spec.commonmark.org/) syntax MAY be used for rich text representation.
# (2) all the url could be URL template(?):
#   Variable substitutions will be made when a variable is named in {brackets}.
#   variables: Map Object, A map between a variable name and its value, is used for substitution in the URL template.
#   variables example: https://github.com/OAI/OpenAPI-Specification/blob/OpenAPI.next/versions/3.0.0.md#server-object-example

BASE_API_CONFIG = {
    # An array of Server Objects, which provide connectivity information to a target server.
    # If the servers property is not provided, or is an empty array,
    #   the default value would be a Server Object with a url value of /.
    # https://swagger.io/docs/specification/api-host-and-base-path/
    #   The servers section specifies the API server and base URL.
    #   You can define one or several servers, such as production and sandbox.
    servers: [
        {
            # [REQUIRED] A URL to the target host.
            # This URL supports Server Variables and MAY be relative,
            #   to indicate that the host location is relative to the location where
            #   the OpenAPI document is being served.
            url: 'http://localhost:3000',
            # An optional string describing the host designated by the URL.
            description: 'Optional server description, e.g. Main (production) server'
        },{
            url: 'http://localhost:3000',
            description: 'Optional server description, e.g. Internal staging server for testing'
        }
    ],

    # Authentication
    #   The securitySchemes and security keywords are used to describe the authentication methods used in your API.
    #   TODO: https://swagger.io/docs/specification/authentication/
    # Security Scheme Object: An object to hold reusable Security Scheme Objects.
    global_security_schemes: {
        ApiKeyAuth: {
            type: 'apiKey',
            name: 'server_token',
            in: 'query'
        }
    },
    # Security Requirement Object
    #   A declaration of which security mechanisms can be used across the API.
    #   The list of values includes alternative security requirement objects that can be used.
    #   Only one of the security requirement objects need to be satisfied to authorize a request.
    #   Individual operations can override this definition.
    # see: https://github.com/OAI/OpenAPI-Specification/blob/OpenAPI.next/versions/3.0.0.md#securityRequirementObject
    global_security: [{ ApiKeyAuth: [] }],
}

require 'open_api'
OpenApi::Config.tap do |c|
  # c.instance_eval do
  #   info
  # end

  # [REQUIRED] The location where .json doc file will be output.
  c.file_output_path = 'public/open_api'

  # Everything about OAS3 is on https://github.com/OAI/OpenAPI-Specification/blob/OpenAPI.next/versions/3.0.0.md
  # Getting started: **https://swagger.io/docs/specification/basic-structure/**
  c.register_docs = {
      homepage_api: {
          # [REQUIRED] ZRO will scan all the descendants of the root_controller, and then generate their docs.
          root_controller: Api::V1::BaseController,

          # [REQUIRED] Info Object: The info section contains API information
          info: {
              # [REQUIRED] The title of the application.
              title: 'Zero Rails APIs',
              # A short description of the application.
              description: 'API documentation of Zero-Rails Application. <br/>' \
                           'Optional multiline or single-line Markdown-formatted description ' \
                           'in [CommonMark](http://spec.commonmark.org/) or `HTML`.',
              # A URL to the Terms of Service for the API. MUST be in the format of a URL.
              # termsOfService: 'http://example.com/terms/',
              # Contact Object: The contact information for the exposed API.
              contact: {
                  # The identifying name of the contact person/organization.
                  name: 'API Support',
                  # The URL pointing to the contact information. MUST be in the format of a URL.
                  url: 'http://www.skippingcat.com',
                  # The email address of the contact person/organization. MUST be in the format of an email address.
                  email: 'x@skippingcat.com'
              },
              # License Object: The license information for the exposed API.
              license: {
                  # [REQUIRED] The license name used for the API.
                  name: 'Apache 2.0',
                  # A URL to the license used for the API. MUST be in the format of a URL.
                  url: 'http://www.apache.org/licenses/LICENSE-2.0.html'
              },
              # [REQUIRED] The version of the OpenAPI document
              # (which is distinct from the OpenAPI Specification version or the API implementation version).
              version: '1.0.0'
          }
      }.merge(BASE_API_CONFIG),


      user_api: {
          root_controller: ApiDoc,
          info: {
              title: 'User',
              version: '0.0.1'
          }
      }.merge(BASE_API_CONFIG)
  }


  c.generate_jbuilder_file  = true
  c.overwrite_jbuilder_file = false
  c.jbuilder_templates = {
      index: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        if @data.nil?
          unless @status
            error_class = Object.const_get("\#{controller_name.camelize}Error") rescue nil
            error_name  = "\#{action_name}_failed"
            if error_class.respond_to? error_name
              @error_info = error_class.send(error_name, :info).values
            end
            @_code, @_msg = @error_info
          end
        
          json.partial! 'api/base', total: 0
          json.data @data || ''
        else
          json.partial! 'api/base', total: @data.size
        
          # @data = @data.page(@_page).per(@_rows) if @_page || @_rows
          # json.data @data.to_a.to_builder
          json.data @data.page(@_page).per(@_rows).to_a.to_builder
        end
      FILE
      ),

      cache_index: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        if @data.nil?
          unless @status
            error_class = Object.const_get("\#{controller_name.camelize}Error") rescue nil
            error_name  = "\#{action_name}_failed"
            if error_class.respond_to? error_name
              @error_info = error_class.send(error_name, :info).values
            end
            @_code, @_msg = @error_info
          end
        
          json.partial! 'api/base', total: 0
          json.data @data || ''
        else
          json.partial! 'api/base', total: @data.size
          
          # @data = @data.page(@_page).per(@_rows) if @_page || @_rows
          json.cache! [ 'key' ], expires_in: 10.minutes do
            # json.data @data.to_a.to_builder
            json.data @data.page(@_page).per(@_rows).to_a.to_builder
          end
        end
      FILE
      ),

      show: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        json.partial! 'api/base', total: 1
        
        json.data @datum.respond_to?(:to_builder) ? @datum.to_builder : @datum
      FILE
      ),

      cache_show: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        json.partial! 'api/base', total: 1
        
        json.cache! [ 'key' ], expires_in: 10.minutes do
          json.datum @datum.respond_to?(:to_builder) ? @datum.to_builder : @datum
        end
      FILE
      ),

      success: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        json.partial! 'api/success'
      FILE
      ),

      success_or_not: (
      <<~FILE
        # *** Generated by ZRO [ please make sure that you have checked this file ] ***
        
        unless @status
          error_class = Object.const_get("\#{controller_name.camelize}Error") rescue nil
          error_name  = "\#{action_name}_failed"
          @error_info = error_class.send(error_name, :info).values if error_class.respond_to? error_name
          @_code, @_msg = @error_info
        end
        
        json.partial! 'api/base', total: 0
        json.data @data || ''
      FILE
      ),
  }

end

Object.const_set('Boolean', 'boolean')

OpenApi.write_docs generate_files: !Rails.env.production?

BaseSpdoc.run
