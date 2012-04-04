require 'test/unit'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + "/../lib/app_config.rb")

class AppConfigTest < Test::Unit::TestCase
  TEST_FILE = '__test_conf'
  TEST_LOCAL_FILE = '#{TEST_FILE}.local'

  def setup
    @dir = File.dirname(__FILE__) + "/"
    AppConfig.config_dir= @dir
    @files = []
  end
  
  def test_should_read_from_yml
    test_config 'common' => {'a' => '1', 'b' => '2'} do |file, hash|
      config = AppConfig.new(file)
      assert_equal_with_hash config, hash['common']
    end
  end
  
  def test_should_throw_on_non_existent_file
    assert_raises Errno::ENOENT do
      config = AppConfig.new('nonexsistentfile')
    end
  end
  
  def test_should_skip_on_non_existent_file_if_specified
    config = AppConfig.new
    config.use_file!('nonexsistentfile', false)
    assert_not_nil config
  end
  
  def test_should_igonre_non_existent_section
    test_config 'common' => {'a' => '1', 'b' => '2' } do |file, hash|
      config = AppConfig.new(file)
      config.use_section!('nonexistentsection')
      assert_equal config.b, '2'
    end
  end
  
  def test_should_parse_yaml_with_erb
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>' } do |file, hash|
      config = AppConfig.new(file)
      assert_equal config.b, 4
    end
  end
  
  def test_should_override_params_with_given_section
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                 'special' => {'a' => 1, 'b' => 5 } do |file, hash|
      config = AppConfig.new(file)
      config.use_section!('special')
      assert_equal_with_hash config, hash['special']
    end
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                'special' => {'b' => 5 } do |file, hash|
      config = AppConfig.new(file)
      config.use_section!('special')
      assert_equal_with_hash config, {'a' => '1', 'b' => 5}
    end    
  end
  
  def test_should_ovveride_params_with_another_file
    test_config({'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                 'special' => {'b' => 5 }}, TEST_FILE) do |file1, hash1|
      test_config({'common' => {'a' => '2'}, 
                   'special' => {'b' => 8 }}, TEST_LOCAL_FILE) do |file2, hash2|                
        config = AppConfig.new(file1)
        assert_equal_with_hash config, {'a' => '1', 'b' => 4}
        config.use_file!(file2)
        assert_equal_with_hash config, {'a' => '2', 'b' => 4}
      end
    end        
  end
  
  def test_should_ovveride_params_with_another_file_and_use_proper_section
    test_config({'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>', 'c' => 2}, 
                 'special' => {'b' => 5, 'd' => 6 },
                 'extra' => {'f' => 4, 'a' => 8}}, TEST_FILE) do |file1, hash1|
      test_config({'common' => {'a' => '2'}, 
                   'special' => {'b' => 8 }}, TEST_LOCAL_FILE) do |file2, hash2|                
        config = AppConfig.new
        config.use_file!(file1)
        config.use_file!(file2)
        config.use_section!('special')
        assert_equal_with_hash config, {'a' => '2', 'b' => 8, 'c' => 2, 'd' => 6}
      end
    end        
  end  
  
  def test_should_load_config_OK
    test_config({'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                 'special' => {'b' => 5 }}, TEST_FILE) do |file1, hash1|
        config = AppConfig.new
        config.load_config!(TEST_FILE, true)
        config.use_section!('special')
        assert_equal_with_hash config, {'a' => '1', 'b' => 5}
    end        
  end
  
  def test_should_fail_on_bad_data_on_file_config
    bad_file_name = '__bad_file'
    file = @dir + bad_file_name + '.yml'
    @files << file
    File.open(file, 'w') do |f|
      f.write 'baddata sl<%=sssss'        
    end
    config = AppConfig.new
    assert_raises TypeError do
      config.load_config!(bad_file_name, true)
    end
  end
  
  def teardown
    begin
      FileUtils.rm @files
    rescue
    end
  end
  
  protected
  
    def file_path(file)
      @dir + file + '.yml'
    end
  
    def create_config_file(file, hash) 
      file = @dir + file + '.yml'
      @files << file
      File.open(file, 'w') do |f|
        f.write hash.to_yaml        
      end
    end
    
    def assert_equal_with_hash(config, hash)    
      hash.each do |key, value|
        assert_equal config.send(key), value
      end
    end
    
    def test_config(hash, file = TEST_FILE, &blk)
      create_config_file file, hash
      blk.call(file_path(file), hash)
    end
   
end