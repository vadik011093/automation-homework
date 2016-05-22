package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.mydsl.myDsl.Test

class MyDslGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
            fsa.generateFile("test/DemoTest.java", toJavaCode(resource))
	}
	
	def toJavaCode(Resource resource) '''
	import org.junit.Test;
	
	import static org.junit.Assert.*;
	
	public class DemoTest {

		«FOR f : resource.allContents.toIterable.filter(Test)»
			«f.compile»
				
		«ENDFOR»
	}
	'''
	
	def compile(Test t) 
	'''
        	@Test
        	public void testMethod() { 
        		
        		«var state = new State()»
        		«FOR p: t.parameters»
        	    	«state.add(p.value.name)»
        			«p.value.clazz» «p.value.name» = new «p.value.clazz»();
        		«FOR f : p.value.fields»
        			«p.value.name».set«f.name.toFirstUpper»(«f.value»);
        		«ENDFOR»
        		«ENDFOR»
        		
        		«t.testClass.name» testBean = new «t.testClass.name»();
        		«t.returnValue.value.clazz» «t.returnValue.value.name» = testBean.«t.method.name»(«state.values.join(', ')»);
        		
        		«FOR f : t.returnValue.value.fields»
        			assertEquals(«t.returnValue.value.name».«f.name»(), «f.value»)
        		«ENDFOR»
        	}
    '''
    
    static class State {
   
	val myList = newArrayList
	
    def add(String name) {
        myList.add(name)
        myList.trimToSize()
    }
    
    def values() {
    	return myList;
    }
    
}
    
}