library angular2.transform.common.options;

import 'package:glob/glob.dart';

import 'annotation_matcher.dart';
import 'mirror_mode.dart';

const CUSTOM_ANNOTATIONS_PARAM = 'custom_annotations';
const ENTRY_POINT_PARAM = 'entry_points';
const FORMAT_CODE_PARAM = 'format_code';
const REFLECT_PROPERTIES_AS_ATTRIBUTES = 'reflect_properties_as_attributes';
// TODO(kegluenq): Remove this after 30 Nov (i/5108).
const REFLECT_PROPERTIES_AS_ATTRIBUTES_OLD = 'reflectPropertiesAsAttributes';
const AMBIENT_DIRECTIVES = 'ambient_directives';
const INIT_REFLECTOR_PARAM = 'init_reflector';
const INLINE_VIEWS_PARAM = 'inline_views';
const MIRROR_MODE_PARAM = 'mirror_mode';

/// Provides information necessary to transform an Angular2 app.
class TransformerOptions {
  final List<Glob> entryPointGlobs;

  /// The path to the files where the application's calls to `bootstrap` are.
  final List<String> entryPoints;

  /// The `BarbackMode#name` we are running in.
  final String modeName;

  /// The [MirrorMode] to use for the transformation.
  final MirrorMode mirrorMode;

  /// Whether to generate calls to our generated `initReflector` code
  final bool initReflector;

  /// The [AnnotationMatcher] which is used to identify angular annotations.
  final AnnotationMatcher annotationMatcher;

  /// Whether to reflect property values as attributes.
  /// If this is `true`, the change detection code will echo set property values
  /// as attributes on DOM elements, which may aid in application debugging.
  final bool reflectPropertiesAsAttributes;

  /// A set of directives that will be automatically passed-in to the template compiler
  /// Format of an item in the list: angular2/lib/src/common/directives.dart#CORE_DIRECTIVES
  final List<String> ambientDirectives;

  /// Whether to format generated code.
  /// Code that is only modified will never be formatted because doing so may
  /// invalidate the source maps generated by `dart2js` and/or other tools.
  final bool formatCode;

  /// Whether to inline views.
  /// If this is `true`, the transformer will *only* make a single pass over the
  /// input files and inline `templateUrl` and `styleUrls` values.
  /// This is undocumented, for testing purposes only, and may change or break
  /// at any time.
  final bool inlineViews;

  TransformerOptions._internal(
      this.entryPoints,
      this.entryPointGlobs,
      this.modeName,
      this.mirrorMode,
      this.initReflector,
      this.annotationMatcher,
      {this.reflectPropertiesAsAttributes,
      this.ambientDirectives,
      this.inlineViews,
      this.formatCode});

  factory TransformerOptions(List<String> entryPoints,
      {String modeName: 'release',
      MirrorMode mirrorMode: MirrorMode.none,
      bool initReflector: true,
      List<ClassDescriptor> customAnnotationDescriptors: const [],
      bool inlineViews: false,
      bool reflectPropertiesAsAttributes: true,
      List<String> ambientDirectives,
      bool formatCode: false}) {
    var annotationMatcher = new AnnotationMatcher()
      ..addAll(customAnnotationDescriptors);
    var entryPointGlobs = entryPoints != null
        ? entryPoints.map((path) => new Glob(path)).toList(growable: false)
        : null;
    return new TransformerOptions._internal(entryPoints, entryPointGlobs,
        modeName, mirrorMode, initReflector, annotationMatcher,
        reflectPropertiesAsAttributes: reflectPropertiesAsAttributes,
        ambientDirectives: ambientDirectives,
        inlineViews: inlineViews,
        formatCode: formatCode);
  }
}