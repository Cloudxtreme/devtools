INAME = deptree
ONAME = graph

make:
	dot -Tps  $(INAME)1.dot -o $(ONAME)1.ps
	dot -Tpdf $(INAME)1.dot -o $(ONAME)1.pdf
	dot -Tpng $(INAME)1.dot -o $(ONAME)1.png
	dot -Tps  $(INAME)2.dot -o $(ONAME)2.ps
	dot -Tpdf $(INAME)2.dot -o $(ONAME)2.pdf
	dot -Tpng $(INAME)2.dot -o $(ONAME)2.png

clean:
	rm -f $(ONAME)*.ps
	rm -f $(ONAME)*.pdf
	rm -f $(ONAME)*.png
