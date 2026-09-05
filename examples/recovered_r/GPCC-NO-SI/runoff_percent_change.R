# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\runoff_percent_change.R
# Source SHA256: 3CC13445652E947B4625CCA1C5190483832E4D39F37122D6E6C410ED6DF3E8C4
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
percent_R_f1r4 <- percent %>% filter(Climate == 'RCP4.5 (2021-2050)')
percent_R_f1r4$GCMs <- factor(percent_R_f1r4$GCMs,levels = unique(percent_R_f1r4$GCMs))
percent_R_f1r8 <- percent %>% filter(Climate == 'RCP8.5 (2021-2050)')
percent_R_f1r8$GCMs <- factor(percent_R_f1r8$GCMs,levels = unique(percent_R_f1r8$GCMs))
percent_R_f2r4 <- percent %>% filter(Climate == 'RCP4.5 (2051-2080)')
percent_R_f2r4$GCMs <- factor(percent_R_f2r4$GCMs,levels = unique(percent_R_f2r4$GCMs))
percent_R_f2r8 <- percent %>% filter(Climate == 'RCP8.5 (2051-2080)')
percent_R_f2r8$GCMs <- factor(percent_R_f2r8$GCMs,levels = unique(percent_R_f2r8$GCMs))

p_r_f1r4 <- percent_R_f1r4 %>% ggplot(aes(x = reorder(GCMs,-PCR),y = PCR,group=Climate)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCR,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_text(aes(label = PCR),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCR)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Runoff change (%)') +
  coord_flip() +
  labs(title = 'Runoff') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5))


p_r_f1r8 <- percent_R_f1r8 %>% ggplot(aes(x = reorder(GCMs,-PCR),y = PCR,group=Climate)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCR,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_text(aes(label = PCR),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCR)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Runoff change (%)') +
  coord_flip() +
  labs(title = 'Runoff') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5))

p_r_f2r4 <- percent_R_f2r4 %>% ggplot(aes(x = reorder(GCMs,-PCR),y = PCR,group=Climate)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCR,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_text(aes(label = PCR),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCR)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Runoff change (%)') +
  coord_flip() +
  labs(title = 'Runoff') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5))

p_r_f2r8 <- percent_R_f2r8 %>% ggplot(aes(x = reorder(GCMs,-PCR),y = PCR,group=Climate)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCR,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= R_flag),size=4, show.legend = F) +
  geom_text(aes(label = PCR),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCR)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Runoff change (%)') +
  coord_flip() +
  labs(title = 'Runoff') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5))

grid.arrange(p_r_f1r4,p_r_f1r8,
             p_r_f2r4,p_r_f2r8,
             ncol=2)


p_r_f1r4 <- percent_R_f1r4 %>% ggplot(aes(x = reorder(GCMs,-PCR),y = PCR,label = R_flag,group=Climate)) +
  geom_bar(stat = 'identity',aes(fill= R_flag),width = 0.5, show.legend = T) +
  geom_hline(aes(yintercept = mean(PCR)),lty='dashed',size = 1) +
  scale_color_manual()
  xlab('') + ylab('Runoff change (%)') +
  coord_flip() +
  labs(title = 'Runoff') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5),
         legend.title = element_blank(),
         legend.position = 'bottom',
         legend.text = element_text(size=13),
         legend.direction = 'horizontal'
  )
p_r_f1r4
ggsave('p_r_f1r4.tif',device = 'tiff',dpi=300,p_r_f1r4)

