library(dplyr)
library(patchwork)
library(ggplot2)

#Data loading
df <- read.csv("Dataset.csv")

#Data re-arrange
fieldwork_year <- df %>%
    count(Publication_Year, Fieldwork) %>%
    group_by(Publication_Year) %>%
    mutate(Total = sum(n),prop = n / Total ) %>% ungroup()

primary_year <- df %>%
    count(Publication_Year, Primary_data) %>%
    group_by(Publication_Year) %>%
    mutate(Total = sum(n),prop = n / Total) %>% ungroup()


#Figure1
#Field work
my_theme <- theme(
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(colour = "grey82", linewidth = 0.3),
    axis.line.x = element_line(colour = "black"),
    axis.line.y = element_line(colour = "black"),
    axis.ticks = element_line(colour = "black"),
    legend.position = c(0.2, 0.8),
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.key = element_rect(fill = "transparent", colour = NA))

p_fieldwork <- ggplot(
    subset(fieldwork_year, Publication_Year > 1989 & Publication_Year < 2025),
    aes(x = Publication_Year, y = n, fill = Fieldwork)) +
    geom_area(alpha = 0.85, position = "stack") +
    labs(x = "Year",y = "Number of publications",title = "Field-based",fill = NULL) +
    scale_fill_manual(values = c("Yes" = "#5B9BCB","No" = "#E49A6A","Unclear" = "grey70")
                      ,breaks = c("Yes", "No", "Unclear")) +
    scale_x_continuous(breaks = seq(1990, 2024, by = 5),
                       limits = c(1990, 2024)) +
    guides(fill = "none")+
    coord_cartesian(xlim = c(1990, 2024), expand = FALSE) +
    annotate("text", x = 2017, y = 5000, label = "Field-based",
             colour = "white", size = 3, fontface = "bold") +
    annotate("text", x = 2017, y = 24000, label = "Non-field-based",
             colour = "black", size = 3, fontface = "bold") +
    annotate("text", x = -Inf, y = Inf, label = "(a)",
             hjust = -0.3, vjust = 1.5,
             colour = "black", size = 4, fontface = "bold")+
    my_theme

# Primary data 
p_primary <- ggplot(subset(primary_year, Publication_Year > 1989 & Publication_Year < 2025),
                         aes(x = Publication_Year, y = n, fill = Primary_data)) +
    geom_area(alpha = 0.85, position = "stack") +
    labs(x = "Year",
         y = "Number of publications",
         title = "Primary data",fill = NULL) +
    scale_fill_manual(values = c("Yes" = "#5B9BCB","No" = "#E49A6A","Unclear" = "grey70")
                      ,breaks = c("Yes", "No", "Unclear")) +
    guides(fill = "none")+
    coord_cartesian(xlim = c(1990, 2024), expand = FALSE) +
    annotate("text", x = 2017, y = 5000, label = "Primary data",
             colour = "white", size = 3, fontface = "bold") +
    annotate("text", x = 2017, y = 26000, label = "Non-primary data",
             colour = "black", size = 3, fontface = "bold") +
    annotate("text", x = -Inf, y = Inf, label = "(c)",
             hjust = -0.3, vjust = 1.5,
             colour = "black", size = 4, fontface = "bold")+
    my_theme

#Proportional data
p_fieldwork2 <- ggplot(
    subset(fieldwork_year, Publication_Year > 1989 & Publication_Year < 2025),
    aes(x = Publication_Year, y = n, fill = Fieldwork)) +
    geom_area(alpha = 0.85, position = "fill") +
    labs(x = "Year",y = "Proportion of studies",title = "",fill = NULL) +
    scale_fill_manual(values = c("Yes" = "#5B9BCB","No" = "#E49A6A","Unclear" = "grey70")
                      ,breaks = c("Yes", "No", "Unclear")) +
    scale_x_continuous(breaks = seq(1990, 2024, by = 5),
                       limits = c(1990, 2024)) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    coord_cartesian(xlim = c(1990, 2024), expand = FALSE) +
    guides(fill = "none")+
    annotate("text", x = 2007, y = 0.5, label = "Field-based",
             colour = "white", size = 3, fontface = "bold") +
    annotate("text", x = 2007, y = 0.92, label = "Non-field-based",
             colour = "black", size = 3, fontface = "bold") +
    annotate("text", x = -Inf, y = Inf, label = "(b)",
             hjust = -0.3, vjust = 1.5,
             colour = "black", size = 4, fontface = "bold")+
    my_theme


# Primary data 
p_primary2 <- ggplot(subset(primary_year, Publication_Year > 1989 & Publication_Year < 2025),
                          aes(x = Publication_Year, y = n, fill = Primary_data)) +
    geom_area(alpha = 0.85, position = "fill") +
    labs(x = "Year",y = "Proportion of studies",title = "",fill = NULL) +
    scale_fill_manual(values = c("Yes" = "#5B9BCB","No" = "#E49A6A","Unclear" = "grey70")
                      ,breaks = c("Yes", "No", "Unclear")) +
    scale_x_continuous(breaks = seq(1990, 2024, by = 5),
                       limits = c(1990, 2024)) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    coord_cartesian(xlim = c(1990, 2024), expand = FALSE) +
    guides(fill = "none")+
    annotate("text", x = 2007, y = 0.5, label = "Primary data",
             colour = "white", size = 3, fontface = "bold") +
    annotate("text", x = 2007, y = 0.95, label = "Non-primary data",
             colour = "black", size = 3, fontface = "bold") +
    annotate("text", x = -Inf, y = Inf, label = "(d)",
             hjust = -0.3, vjust = 1.5,colour = "black", size = 4, fontface = "bold")+
    my_theme  


#Plot output
jpeg("Figure1.jpg", width = 8, height = 7, units = "in", res = 800)
print((p_fieldwork/p_primary) | (p_fieldwork2/p_primary2))
dev.off()


#Figure 2
df_journal <- read.csv("Dataset_journal.csv")

#Some calculation
df_journal$prop_field <- df_journal$Field_yes / df_journal$Total
df_journal$prop_primary <- df_journal$Primary_yes / df_journal$Total


df_journal_q <- df_journal  %>% 
    mutate(X5_Year_JIF = suppressWarnings(as.numeric(trimws(X5_Year_JIF)))) %>%
    filter(!is.na(X5_Year_JIF)) %>% 
    select(Journal,X5_Year_JIF,X5_Year_JIF_Quartile,prop_field,prop_primary,Total)%>%
    distinct

#With 5 Quantile
df_journal_q$Quartile <- as.factor(df_journal_q$X5_Year_JIF_Quartile)

n_by_q <- df_journal_q %>% count(Quartile) %>%
    mutate(label = paste0(Quartile, "\n(n=", n, ")"))
df_journal_q <- df_journal_q %>% left_join(n_by_q, by = "Quartile")

# Labels
med_fw <- df_journal_q %>% subset(Total>10) %>%
    group_by(Quartile, label) %>%
    summarise(m = mean(prop_field), 
              sd = sd(prop_field),.groups = "drop")
med_fw$m2 <- paste0(round(med_fw$m*100,0),"%")

med_pd <- df_journal_q %>% subset(Total>10) %>%
    group_by(Quartile, label) %>%
    summarise(m = mean(prop_primary), 
              sd = sd(prop_primary),.groups = "drop")
med_pd$m2 <- paste0(round(med_pd$m*100,0),"%")


#Plot results - with 5 year IF, only with > 10 records. 
df_journal_q_s <-  subset(df_journal_q, Total > 10)

#Statistics, comparing with Q1
md_field <- glm(prop_field ~ Quartile,family = quasibinomial(link = "logit"), data = df_journal_q_s)
summary(md_field)

# Primary-data studies
md_primary <- glm(prop_primary ~ Quartile,family = quasibinomial(link = "logit"),data = df_journal_q_s)
summary(md_primary)

# Overall tests
anova(md_field, test = "F")
anova(md_primary, test = "F")

#Plot Figure2
theme_z <- 
    theme_classic(base_size = 8, base_family = "Arial") +
    theme(
        axis.line = element_line(linewidth = 0.4, colour = "#333333"),
        axis.ticks = element_line(linewidth = 0.3, colour = "#333333"),
        axis.ticks.length = unit(1.5, "mm"),
        axis.title = element_text(size = 8, colour = "#333333"),
        axis.text = element_text(size = 7, colour = "#333333"),
        panel.grid.major.y = element_line(linewidth = 0.2, colour = "#CCCCCC"),
        panel.grid.major.x = element_blank(),
        plot.tag = element_text(size = 11, face = "bold"),
        plot.margin = margin(5, 10, 5, 5))

p_journal_field_q <- 
    ggplot(data = df_journal_q_s, 
           aes(x = Quartile, y = prop_field))+
    geom_boxplot(fill = "#4A90C4", colour = "#555555", alpha = 0.75,outlier.shape = NA,
                 linewidth = 0.4, width = 0.45) +
    geom_jitter(width = 0.12, size = 0.6, alpha = 0.3, colour = "#4A90C4") +
    geom_text(data = med_fw,
              aes(x = Quartile, y = 1.05, label = m2),
              size = 2.5, fontface = "bold", colour = "#333333")+
    scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.25),
                       labels = scales::percent_format(accuracy = 1))+
    labs(x = "Five-year impact factor Quantile",
         y = "Field-based stuies %",
         tag = "(a)")+theme_z

p_journal_primary_q <- 
    ggplot(data = df_journal_q_s, 
           aes(x = Quartile, y = prop_primary))+
    geom_boxplot(fill = "#E8956A", colour = "#555555", alpha = 0.75,outlier.shape = NA,
                 linewidth = 0.4, width = 0.45) +
    geom_jitter(width = 0.12, size = 0.6, alpha = 0.3, colour = "#E8956A") +
    geom_text(data = med_pd,
              aes(x = Quartile, y = 1.05, label = m2),
              size = 2.5, fontface = "bold", colour = "#333333")+
    scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.25),
                       labels = scales::percent_format(accuracy = 1))+
    labs(x = "Five-year impact factor Quantile",
         y = "Primary data studies %",
         tag = "(b)")+
    theme_z

#Plot output
jpeg("Figure2.jpg", width = 7.5, height = 3.5, units = "in", res = 1200)
(panelA_q <- p_journal_field_q | p_journal_primary_q )
dev.off()
