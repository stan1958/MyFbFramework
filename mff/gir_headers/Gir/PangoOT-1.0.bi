'            FreeBasic header file, auto-generated by
'                       ### girtobac ###
' LGPLv2.1 (C) 2013-2022 by Thomas{ doT ]Freiherr[ At ]gmx[ DoT }net
' Auto-translated from file /usr/share/gir-1.0/PangoOT-1.0.gir
#INCLUDE ONCE "_GirToBac-0.0.bi"
' Repository version 1.2
#INCLUDE ONCE "PangoFc-1.0.bi"
#INCLUDE ONCE "freetype2-2.0.bi"
TYPE AS guint32 PangoOTTag
#DEFINE PANGO_OT_ALL_GLYPHS 65535
TYPE AS _PangoOTBuffer PangoOTBuffer
#DEFINE PANGO_OT_DEFAULT_LANGUAGE 65535
TYPE AS _PangoOTFeatureMap PangoOTFeatureMap
TYPE AS _PangoOTGlyph PangoOTGlyph
TYPE AS _PangoOTInfo PangoOTInfo
#DEFINE PANGO_OT_NO_FEATURE 65535
#DEFINE PANGO_OT_NO_SCRIPT 65535
TYPE AS _PangoOTRuleset PangoOTRuleset
TYPE AS _PangoOTRulesetDescription PangoOTRulesetDescription
TYPE AS LONG PangoOTTableType
ENUM
  PANGO_OT_TABLE_GSUB = 0
  PANGO_OT_TABLE_GPOS = 1
END ENUM
EXTERN "C" LIB "pangoft2-1.0"
' P_X

' P_3

DECLARE SUB pango_ot_buffer_add_glyph(BYVAL AS PangoOTBuffer PTR, BYVAL AS guint, BYVAL AS guint, BYVAL AS guint)
DECLARE SUB pango_ot_buffer_clear(BYVAL AS PangoOTBuffer PTR)
DECLARE SUB pango_ot_buffer_destroy(BYVAL AS PangoOTBuffer PTR)
DECLARE SUB pango_ot_buffer_get_glyphs(BYVAL AS const PangoOTBuffer PTR, BYVAL AS PangoOTGlyph PTR PTR, BYVAL AS gint PTR)
DECLARE SUB pango_ot_buffer_output(BYVAL AS const PangoOTBuffer PTR, BYVAL AS PangoGlyphString PTR)
DECLARE SUB pango_ot_buffer_set_rtl(BYVAL AS PangoOTBuffer PTR, BYVAL AS gboolean)
DECLARE SUB pango_ot_buffer_set_zero_width_marks(BYVAL AS PangoOTBuffer PTR, BYVAL AS gboolean)
DECLARE FUNCTION pango_ot_buffer_new(BYVAL AS PangoFcFont PTR) AS PangoOTBuffer PTR
TYPE _PangoOTFeatureMap
  AS char /'?'/ feature_name(4)
  AS gulong property_bit
END TYPE
TYPE _PangoOTGlyph
  AS guint32 glyph
  AS guint properties
  AS guint cluster
  AS gushort component
  AS gushort ligID
  AS guint internal
END TYPE
DECLARE FUNCTION pango_ot_info_get_type() AS GType
#DEFINE PANGOOT_TYPE_OT_INFO (pango_ot_info_get_type())
#DEFINE PANGOOT_OT_INFO(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), PANGOOT_TYPE_OT_INFO, PangoOTInfo))
#DEFINE PANGOOT_OT_INFO_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), PANGOOT_TYPE_OT_INFO, PangoOT))
#DEFINE PANGOOT_IS_OT_INFO(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), PANGOOT_TYPE_OT_INFO))
#DEFINE PANGOOT_IS_CLASS_OT_INFO(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), PANGOOT_TYPE_OT_INFO))
#DEFINE PANGOOT_OT_INFO_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), PANGOOT_TYPE_OT_INFO, PangoOT))
DECLARE FUNCTION pango_ot_info_get(BYVAL AS any ptr /'FT_Face'/) AS PangoOTInfo PTR
DECLARE FUNCTION pango_ot_info_find_feature(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType, BYVAL AS PangoOTTag, BYVAL AS guint, BYVAL AS guint, BYVAL AS guint PTR) AS gboolean
DECLARE FUNCTION pango_ot_info_find_language(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType, BYVAL AS guint, BYVAL AS PangoOTTag, BYVAL AS guint PTR, BYVAL AS guint PTR) AS gboolean
DECLARE FUNCTION pango_ot_info_find_script(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType, BYVAL AS PangoOTTag, BYVAL AS guint PTR) AS gboolean
DECLARE FUNCTION pango_ot_info_list_features(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType, BYVAL AS PangoOTTag, BYVAL AS guint, BYVAL AS guint) AS PangoOTTag PTR
DECLARE FUNCTION pango_ot_info_list_languages(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType, BYVAL AS guint, BYVAL AS PangoOTTag) AS PangoOTTag PTR
DECLARE FUNCTION pango_ot_info_list_scripts(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoOTTableType) AS PangoOTTag PTR
DECLARE FUNCTION pango_ot_ruleset_get_type() AS GType
#DEFINE PANGOOT_TYPE_OT_RULESET (pango_ot_ruleset_get_type())
#DEFINE PANGOOT_OT_RULESET(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), PANGOOT_TYPE_OT_RULESET, PangoOTRuleset))
#DEFINE PANGOOT_OT_RULESET_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), PANGOOT_TYPE_OT_RULESET, PangoOT))
#DEFINE PANGOOT_IS_OT_RULESET(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), PANGOOT_TYPE_OT_RULESET))
#DEFINE PANGOOT_IS_CLASS_OT_RULESET(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), PANGOOT_TYPE_OT_RULESET))
#DEFINE PANGOOT_OT_RULESET_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), PANGOOT_TYPE_OT_RULESET, PangoOT))
DECLARE FUNCTION pango_ot_ruleset_new(BYVAL AS PangoOTInfo PTR) AS PangoOTRuleset PTR
DECLARE FUNCTION pango_ot_ruleset_new_for(BYVAL AS PangoOTInfo PTR, BYVAL AS PangoScript, BYVAL AS PangoLanguage PTR) AS PangoOTRuleset PTR
DECLARE FUNCTION pango_ot_ruleset_new_from_description(BYVAL AS PangoOTInfo PTR, BYVAL AS const PangoOTRulesetDescription PTR) AS PangoOTRuleset PTR
DECLARE FUNCTION pango_ot_ruleset_get_for_description(BYVAL AS PangoOTInfo PTR, BYVAL AS const PangoOTRulesetDescription PTR) AS const PangoOTRuleset PTR
DECLARE SUB pango_ot_ruleset_add_feature(BYVAL AS PangoOTRuleset PTR, BYVAL AS PangoOTTableType, BYVAL AS guint, BYVAL AS gulong)
DECLARE FUNCTION pango_ot_ruleset_get_feature_count(BYVAL AS const PangoOTRuleset PTR, BYVAL AS guint PTR, BYVAL AS guint PTR) AS guint
DECLARE FUNCTION pango_ot_ruleset_maybe_add_feature(BYVAL AS PangoOTRuleset PTR, BYVAL AS PangoOTTableType, BYVAL AS PangoOTTag, BYVAL AS gulong) AS gboolean
DECLARE FUNCTION pango_ot_ruleset_maybe_add_features(BYVAL AS PangoOTRuleset PTR, BYVAL AS PangoOTTableType, BYVAL AS const PangoOTFeatureMap PTR, BYVAL AS guint) AS guint
DECLARE SUB pango_ot_ruleset_position(BYVAL AS const PangoOTRuleset PTR, BYVAL AS PangoOTBuffer PTR)
DECLARE SUB pango_ot_ruleset_substitute(BYVAL AS const PangoOTRuleset PTR, BYVAL AS PangoOTBuffer PTR)
TYPE _PangoOTRulesetDescription
  AS PangoScript script
  AS PangoLanguage PTR language
  AS const PangoOTFeatureMap PTR static_gsub_features
  AS guint n_static_gsub_features
  AS const PangoOTFeatureMap PTR static_gpos_features
  AS guint n_static_gpos_features
  AS const PangoOTFeatureMap PTR other_features
  AS guint n_other_features
END TYPE
DECLARE FUNCTION pango_ot_ruleset_description_copy(BYVAL AS const PangoOTRulesetDescription PTR) AS PangoOTRulesetDescription PTR
DECLARE FUNCTION pango_ot_ruleset_description_equal(BYVAL AS const PangoOTRulesetDescription PTR, BYVAL AS const PangoOTRulesetDescription PTR) AS gboolean
DECLARE SUB pango_ot_ruleset_description_free(BYVAL AS PangoOTRulesetDescription PTR)
DECLARE FUNCTION pango_ot_ruleset_description_hash(BYVAL AS const PangoOTRulesetDescription PTR) AS guint
' P_4

DECLARE FUNCTION pango_ot_tag_from_language(BYVAL AS PangoLanguage PTR) AS PangoOTTag
DECLARE FUNCTION pango_ot_tag_from_script(BYVAL AS PangoScript) AS PangoOTTag
DECLARE FUNCTION pango_ot_tag_to_language(BYVAL AS PangoOTTag) AS PangoLanguage PTR
DECLARE FUNCTION pango_ot_tag_to_script(BYVAL AS PangoOTTag) AS PangoScript
END EXTERN

