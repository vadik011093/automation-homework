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
	
	def compile(Test t) '''
        	@Test
        	public void testMethod() { 
        		assertEquals(new «t.testClass.name»().«t.method.name»(«t.parameters»), «t.returnValue»)
        	}
    '''
}