#"""
#Supports only python2
#"""
import os
import os.path
import sys
import tempfile
import tarfile
import shutil
import copy


def str_filter( s ):
	s = s.replace(" ","")
	s = s.replace(".","")
	s = s.replace("=","")
	s = s.replace("-","")
	s = s.replace("(","")
	s = s.replace(")","")
	return s

def write_dep_graph( dep, fname="./deptree1.dot" ):
	dep_graph = open(fname,"w")
	dep_graph.write("digraph G {\n")
	dep_graph.write("""
overlap=scale;
ratio="fill";
overlap="prism";
ranksep = 1.5;
splines=true;
sep="+25,25";
overlap=scalexy;
edge [arrowsize=1.0];
fontname="Monospace";
""")
	for name in dep:
		for deps_dep in dep[name]:
			dep_graph.write("%s -> %s;\n"%(name, deps_dep))
	dep_graph.write("}\n")
	dep_graph.close()

packages = {}

if len( sys.argv ) != 2:
	print "at least 1 argument ./deptree.py [path_to_packages]"
	sys.exit(-1)

#open dir
full_path = os.path.abspath( sys.argv[1] )
print full_path



count_tot_edges = 0
file_list = os.listdir( full_path )
for f_l in file_list:
	if (f_l[-4:] == ".ipk") and (tarfile.is_tarfile(full_path+"/"+f_l)):
		print f_l
		temp_dir = tempfile.mkdtemp( prefix="deptree_" )
		pkg = tarfile.open( name = full_path+"/"+f_l )
		pkg.extract( "./control.tar.gz", temp_dir )
		pkg.close()
		
		pkg_control = tarfile.open( name = temp_dir+"/control.tar.gz" )
		pkg_control.extract( "./control", temp_dir )
		pkg.close()

		f = open( temp_dir+"/control" )
		i = 0
		name = None
		deps = None
		for line in f:
			if i == 0:
				name = line.strip("\n").split(":")[1]
				name = str_filter( name )
			if i == 2:
				deps = line.strip("\n").split(":")[1].split(",")
			i+=1
		f.close()
		
		print name," - - ",deps

		shutil.rmtree( temp_dir )

		for dep in deps:
			dep = str_filter( dep )
			if dep != "":
				#if config.use_filter and (name in config.pkgs) and (dep in config.pkgs):
				#	dep_graph.write("%s -> %s;\n"%(name, dep))
				count_tot_edges += 1
				if name in packages:
					a = packages[name]
					a.append(dep)
					packages[name] = a
				else:
					c = ord(name[0])
					if (c >= ord('0')) and (c <= ord('9')):
						name1 = "_"+name[1:]
						packages[name1] = [dep]
					else:
						packages[name] = [dep]

#print packages
write_dep_graph( packages )

packages2 = copy.deepcopy( packages )
print "Total dep edges = ", count_tot_edges
count_l1_dep = 0
for l1 in packages:
	dep1 = packages[l1]
	for l2 in dep1:
		if l2 in packages:
			dep2 = packages[l2]
			for l3 in dep2:
				if l3 in dep1:
					print l1,"->",l2,"->",l3, " and ", l1, "->", l3
					count_l1_dep += 1
					t1 = packages2[l1]
					try:
						t1.remove( l3 )
					except:
						pass
					packages2[l1] = t1
			
write_dep_graph( packages2, fname="deptree2.dot" )

print "Level 1 dep = ", count_l1_dep



