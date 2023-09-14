/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:reflectable/reflectable.dart';

class MirrorFeature {

    /// It checks if a parameter has a specific annotation
    ///
    /// Args:
    ///   declaration (ParameterMirror): The parameter that we're checking for the
    /// annotation.
    ///   annotation (Type): The annotation class to check for.
    ///
    /// Returns:
    ///   A bool.
    static bool isParameterPresent(ParameterMirror declaration, Type annotation) {
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
               return true;
            }
        }

        return false;
    }

    /// It checks if a given declaration has a given annotation
    ///
    /// Args:
    ///   declaration (DeclarationMirror): The declaration to check for the
    /// annotation.
    ///   annotation (Type): The annotation class to check for.
    ///
    /// Returns:
    ///   A bool.
    static bool isAnnotationPresent(DeclarationMirror declaration, Type annotation) {
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
               return true;
            }
        }

        return false;
    }

    /// It returns the first instance of the annotation of type `annotation` found
    /// in the metadata of `declaration`
    ///
    /// Args:
    ///   declaration (DeclarationMirror): The declaration to get the annotation
    /// from.
    ///   annotation (Type): The annotation class to look for.
    ///
    /// Returns:
    ///   A list of all the annotations on the declaration.
    static dynamic getAnnotation(DeclarationMirror declaration, Type annotation) {
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
                return instance;
            }
        }

        return null;
    }

    /// It returns the first instance of the annotation type passed in as a
    /// parameter
    ///
    /// Args:
    ///   declaration (ParameterMirror): The parameter that we're looking for the
    /// annotation on.
    ///   annotation (Type): The annotation class you want to get the value of.
    ///
    /// Returns:
    ///   The value of the annotation.
    static dynamic getParameter(ParameterMirror declaration, Type annotation) {
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
                return instance;
            }
        }

        return null;
    }

    /// It returns a list of all the annotations of a given type on a given
    /// declaration
    ///
    /// Args:
    ///   declaration (DeclarationMirror): The declaration to search for annotations
    /// on.
    ///   annotation (Type): The annotation class you want to find.
    ///
    /// Returns:
    ///   A list of all the annotations of the given type.
    static List<dynamic> getAnnotations(DeclarationMirror declaration, Type annotation) {
        var result = [];
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
                result.add(instance);
            }
        }

        return result;
    }

    /// It returns a list of all the metadata annotations of a given type that are
    /// attached to a given variable
    ///
    /// Args:
    ///   declaration (VariableMirror): The variable declaration.
    ///   annotation (Type): The annotation you want to get the variables for.
    ///
    /// Returns:
    ///   A list of all the instances of the annotation that are found in the
    /// declaration.
    static List<dynamic> getVariables(VariableMirror declaration, Type annotation) {
        var result = [];
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
                result.add(instance);
            }
        }

        return result;
    }

    /// It returns the first instance of the given annotation type found on the
    /// given declaration
    ///
    /// Args:
    ///   declaration (TypeMirror): The type to get the annotation from.
    ///   annotation (Type): The annotation class to look for.
    ///
    /// Returns:
    ///   An instance of the annotation.
    static Object getTypeAnnotation(TypeMirror declaration, Type annotation) {
        for (var instance in declaration.metadata) {
            if (instance.runtimeType == annotation) {
                return instance;
            }
        }

        // ignore: null_check_always_fails
        return null!;
    }
}