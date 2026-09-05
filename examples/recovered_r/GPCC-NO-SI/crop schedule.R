# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\crop schedule.R
# Source SHA256: 62CF9635B49B64220DAF92DC962B296D9371F83460CC298A10EBAF9B9088BADA
#
# Sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific Windows absolute paths and email addresses were redacted.
# R regular-expression strings are preserved exactly; they are not interpreted
# as UNC/network paths.
#
# Scientific statements/calculations are retained as historical provenance.
# This script may require historical data objects, working directories,
# package versions, and upstream workflow state that are not distributed here.
# ============================================================================
library(ganttrify)

crop_schedule <- read.csv('cropping schedule.csv',header = T)
head(crop_schedule)
colnames(crop_schedule) <- c('wp','activity','start_date','end_date')
crop_schedule$wp <- factor(crop_schedule$wp,ordered = T,
                           levels = c('Continuous winter wheat',
                                      'Three-year wheat-alfalfa rotation',
                                      'Winter wheat-summer soybean double crops'))

spot <- read.csv('spot.csv',header=T)
head(spot)
colnames(spot) <- c('activity','spot_type','spot_date')

ganttrify(project = crop_schedule,
          spots = spot,
          project_start_date = "2020-01",
          font_family = "Arial",
          line_end = 'butt',
          axis_text_align = 'right',
          month_number_label = T,
          month_date_label = T) +
  ggplot2::labs(title = "",
                subtitle = "",
                caption = "") +
  xlab('Month') +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = 'right',
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         strip.text = element_text(size=14)
  )


#ggsave('croping_schedule.tiff',device = 'tiff',dpi= 600)
