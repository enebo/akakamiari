require 'ant'

# The lower you set this the less ant internal debugging output you will see..
output_level = 5

Ant.new(:output_level => output_level) do
  # Regular Ruby variable interact fine
  build_dir = "java_build"

  # But defining and consuming ant properties is fine
  property :name => "src.dir", :value => "java_src"

  # This will end up not being used by ant because there is no 'classes'
  # directory.  It is useful to see that ant figures this out when the
  # debug output_level is higher. You should see a message like:
  # 'dropping .../akakamiari/samples/classes from path as it doesn't exist'
  path(:id => "project.class.path") do
    pathelement :location => "classes"
  end

  echo :message => "SOURCE DIR IS: ${src.dir}"
  echo :message => "BUILD DIR IS: ${build.dir}"

  mkdir :dir => build_dir
  javac(:destdir => build_dir) do
    classpath :refid => "project.class.path"
    src do
      pathelement :location => "${src.dir}"
    end
  end
  jar :destfile => "simple_compile.jar", :basedir => build_dir
end
