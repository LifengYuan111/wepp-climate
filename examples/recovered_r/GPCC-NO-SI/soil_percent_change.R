# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\soil_percent_change.R
# Source SHA256: 561216540EED7D95F7C281AD6AE23A6C9D2C5BC0F162A41F9554D63630DC447B
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
percent_S_f1r4 <- percent %>% filter(Climate == 'RCP4.5 (2021-2050)')
percent_S_f1r4$GCMs <- factor(percent_S_f1r4$GCMs,levels = unique(percent_S_f1r4$GCMs))
percent_S_f1r8 <- percent %>% filter(Climate == 'RCP8.5 (2021-2050)')
percent_S_f1r8$GCMs <- factor(percent_S_f1r8$GCMs,levels = unique(percent_S_f1r8$GCMs))
percent_S_f2r4 <- percent %>% filter(Climate == 'RCP4.5 (2051-2080)')
percent_S_f2r4$GCMs <- factor(percent_S_f2r4$GCMs,levels = unique(percent_S_f2r4$GCMs))
percent_S_f2r8 <- percent %>% filter(Climate == 'RCP8.5 (2051-2080)')
percent_S_f2r8$GCMs <- factor(percent_S_f2r8$GCMs,levels = unique(percent_S_f2r8$GCMs))

p_s_f1r4 <- percent_S_f1r4 %>% ggplot(aes(x = reorder(GCMs,-PCSL),y = PCSL,group=Climate)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCSL,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_text(aes(label = PCSL),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCSL)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Soil loss change (%)') +
  labs(title = 'Soil loss') +
  coord_flip() +
  facet_wrap(.~Climate,scales = 'free',strip.position = 'right') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5),
         strip.text = element_text(size=14))


p_s_f1r8 <- percent_S_f1r8 %>% ggplot(aes(x = reorder(GCMs,-PCSL),y = PCSL,group=Climate)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCSL,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_text(aes(label = PCSL),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCSL)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Soil loss change (%)') +
  labs(title = 'Soil loss') +
  coord_flip() +
  facet_wrap(.~Climate,scales = 'free',strip.position = 'right') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5),
         strip.text = element_text(size=14))

p_s_f2r4 <- percent_S_f2r4 %>% ggplot(aes(x = reorder(GCMs,-PCSL),y = PCSL,group=Climate)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCSL,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_text(aes(label = PCSL),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCSL)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Soil loss change (%)') +
  labs(title = 'Soil loss') +
  coord_flip() +
  facet_wrap(.~Climate,scales = 'free',strip.position = 'right') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5),
         strip.text = element_text(size=14))

p_s_f2r8 <- percent_S_f2r8 %>% ggplot(aes(x = reorder(GCMs,-PCSL),y = PCSL,group=Climate)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_segment(aes(y=0,
                   x=GCMs,
                   yend=PCSL,
                   xend = GCMs)) +
  geom_point(stat = 'identity',aes(col= S_flag),size= 4, show.legend = F) +
  geom_text(aes(label = PCSL),color='black',size=2) +
  geom_hline(aes(yintercept = mean(PCSL)),lty='dashed',color='purple',size = 1) +
  xlab('') + ylab('Soil loss change (%)') +
  labs(title = 'Soil loss') +
  coord_flip() +
  facet_wrap(.~Climate,scales = 'free',strip.position = 'right') +
  theme_bw() +
  theme( plot.title = element_text(hjust = 0.5),
         strip.text = element_text(size=14))


grid.arrange(p_s_f1r4,p_s_f1r8,
             p_s_f2r4,p_s_f2r8,
             ncol=2)



# share legends in gridExtra
grid_arrange_shared_legend <-
  function(...,
           ncol = length(list(...)),
           nrow = 1,
           position = c("bottom", "right")) {
    
    plots <- list(...)
    position <- match.arg(position)
    g <-
      ggplotGrob(plots[[1]] + theme(legend.position = position))$grobs
    legend <- g[[which(sapply(g, function(x)
      x$name) == "guide-box")]]
    lheight <- sum(legend$height)
    lwidth <- sum(legend$width)
    gl <- lapply(plots, function(x)
      x + theme(legend.position = "none"))
    gl <- c(gl, ncol = ncol, nrow = nrow)
    
    combined <- switch(
      position,
      "bottom" = arrangeGrob(
        do.call(arrangeGrob, gl),
        legend,
        ncol = 1,
        heights = unit.c(unit(1, "npc") - lheight, lheight)
      ),
      "right" = arrangeGrob(
        do.call(arrangeGrob, gl),
        legend,
        ncol = 2,
        widths = unit.c(unit(1, "npc") - lwidth, lwidth)
      )
    )
    
    grid.newpage()
    grid.draw(combined)
    
    # return gtable invisibly
    invisible(combined)
    
  }
