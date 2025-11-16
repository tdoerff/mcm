project('swami', 'c',
  version : '1.0.1',
  license: 'MIT',
  meson_version: '>=0.64.0',
  default_options : ['warning_level=2'],
)

add_languages('fortran')

# Set up python
py_mod = import('python')
py = py_mod.find_installation(pure: false)
py_dep = py.dependency()

# Derive the package directory as installation path for the binary
install_dir = py.get_install_dir() / 'swami/'

# Find netcdf libs
netcdff_lib = dependency('netcdf', language: 'fortran')

# Step into subdirectories where the build happens.
subdir('src')

install_subdir(
    'data/',
    install_dir: install_dir
)

# Get the depencies for numpy and f2py
incdir_numpy = run_command(py,
  ['-c', 'import os; os.chdir(".."); import numpy; print(numpy.get_include())'],
  check : true
).stdout().strip()

incdir_f2py = run_command(py,
    ['-c', 'import os; os.chdir(".."); import numpy.f2py; print(numpy.f2py.get_include())'],
    check : true
).stdout().strip()

inc_np = include_directories(incdir_numpy, incdir_f2py)

source_dir = './src/swami'
mod_name='mcm_wrapper'

# Generate the wrapper source files for the f2py module
mod_f2py_source = custom_target(
    mod_name + 'module.c',
    input : [source_dir / mod_name + '.f90'],
    output : [
        mod_name + 'module.c',
        mod_name + '-f2pywrappers.f'],
    command : [py, '-m', 'numpy.f2py', '@INPUT@', '-m', mod_name]
)

py.extension_module(mod_name,
  [source_dir / mod_name + '.f90', mod_f2py_source],
  incdir_f2py / 'fortranobject.c',
  link_with : dtm_lib,
  include_directories : inc_np,
  dependencies : py_dep,
  install : true,
  subdir : 'swami'
)

message('✔ Configuration for swami complete.')
message('Python version:      ' + py.version())
message('Install location:    ' + py.get_install_dir())
