module ApplicationHelper

  # so that devise does not screw up
  def resource_name
    :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def user_description_template
    y = YAML.load(File.new("#{Rails.root}/config/user_description_categories.yml").read)
    y[I18n.locale.to_s]
  end

  def s3_uploader(options = {})
    options[:s3_config_filename] ||= "#{Rails.root}/config/s3.yml"
    config = YAML.load_file(options[:s3_config_filename])[Rails.env].symbolize_keys
    bucket            = config[:bucket_name]
    access_key_id     = config[:access_key_id]
    secret_access_key = config[:secret_access_key]

    options[:key] ||= 'test'  # folder on AWS to store file in
    options[:acl] ||= 'public-read'
    options[:expiration_date] ||= 10.hours.from_now.utc.iso8601
    options[:max_filesize] ||= 500.megabytes
    options[:content_type] ||= 'image/' # Videos would be binary/octet-stream
    options[:filter_title] ||= 'Images'
    options[:filter_extentions] ||= 'jpg,jpeg,gif,png,bmp'

    id = options[:id] ? "_#{options[:id]}" : ''

    policy = Base64.encode64(
        "{'expiration': '#{options[:expiration_date]}',
        'conditions': [
          {'bucket': '#{bucket}'},
          {'acl': '#{options[:acl]}'},
          {'success_action_status': '201'},
          ['content-length-range', 0, #{options[:max_filesize]}],
          ['starts-with', '$key', ''],
          ['starts-with', '$Content-Type', ''],
          ['starts-with', '$name', ''],
          ['starts-with', '$Filename', '']
        ]
      }").gsub(/\n|\r/, '')

    signature = Base64.encode64(
        OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            secret_access_key, policy)).gsub("\n","")

    out = ""

    out << javascript_tag("$(function() {

      /*
       * S3 Uploader instance
      */
      // image uploader via plupload
        var uploader = new plupload.Uploader({
            runtimes : 'flash,silverlight',
            browse_button : 'pickfiles',
            max_file_size : '500mb',
            url : 'http://#{bucket}.s3.amazonaws.com/',
            flash_swf_url: '/assets/plupload/js/plupload.flash.swf',
            silverlight_xap_url: '/assets/plupload/js/plupload.silverlight.xap',
            init : {
              FilesAdded: function(up, files) {
                plupload.each(files, function(file) {
                  if (up.files.length > 1) {
                    up.removeFile(file);
                  }
                });
                if (up.files.length >= 1) {
                  $('#pickfiles').fadeOut('slow');
                }
              },
              FilesRemoved: function(up, files) {
                if (up.files.length < 1) {
                  $('#pickfiles').fadeIn('slow');
                }
              }
            },
            multi_selection: false,
            multipart: true,
            multipart_params: {
              'key': 'test/${filename}',
              'Filename': '${filename}', // adding this to keep consistency across the runtimes
        			'acl': '#{options[:acl]}',
        			'Content-Type': '#{options[:content_type]}',
        			'success_action_status': '201',
        			'AWSAccessKeyId' : '#{access_key_id}',
        			'policy': '#{policy}',
        			'signature': '#{signature}'
             },
            filters : [
                {title : '#{options[:filter_title]}', extensions : '#{options[:filter_extentions]}'}
            ],
            file_data_name: 'file'
        });

        // instantiates the uploader
        uploader.init();

        // shows the progress bar and kicks off uploading
        uploader.bind('FilesAdded', function(up, files) {
            $('#progress_bar .ui-progress').css('width', '5%');
            $('span.ui-label').show();

            // start the uploader after the progress bar shows
            $('#progress_bar').show('fast', function () {
              uploader.start();
            });
        });

        // binds progress to progress bar
        uploader.bind('UploadProgress', function(up, file) {
            if(file.percent < 100){
                $('#progress_bar .ui-progress').css('width', file.percent+'%');
            }
            else {
                $('#progress_bar .ui-progress').css('width', '100%');
                $('span.ui-label').text('Complete');
            }
        });

        // shows error object in the browser console (for now)
        uploader.bind('Error', function(up, error) {
          // unfortunately PLUpload gives some extremely vague
          // Flash error messages so you have to use WireShark
          // for debugging them (read the README)

          alert('There was an error.  Check the browser console log for more info');
          console.log('Expand the error object below to see the error. Use WireShark to debug.');

          console.log(error);
        });

    });")

  end

end
