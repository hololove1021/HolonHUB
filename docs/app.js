(() => {
    const data = window.HOLON_SITE_DATA;
    const localeKeys = Object.keys(data.locales);

    const elements = {
        brandVersion: document.getElementById("brand-version"),
        localeLabel: document.getElementById("locale-label"),
        localeSelect: document.getElementById("locale-select"),
        heroEyebrow: document.getElementById("hero-eyebrow"),
        heroSubtitle: document.getElementById("hero-subtitle"),
        heroLead: document.getElementById("hero-lead"),
        ctaDiscord: document.getElementById("cta-discord"),
        ctaTikTok: document.getElementById("cta-tiktok"),
        ctaYouTube: document.getElementById("cta-youtube"),
        statsGrid: document.getElementById("stats-grid"),
        snapshotKicker: document.getElementById("snapshot-kicker"),
        snapshotTitle: document.getElementById("snapshot-title"),
        snapshotBody: document.getElementById("snapshot-body"),
        snapshotList: document.getElementById("snapshot-list"),
        sourcePills: document.getElementById("source-pills"),
        overviewKicker: document.getElementById("overview-kicker"),
        overviewTitle: document.getElementById("overview-title"),
        overviewBody: document.getElementById("overview-body"),
        detailList: document.getElementById("detail-list"),
        systemsKicker: document.getElementById("systems-kicker"),
        systemsTitle: document.getElementById("systems-title"),
        systemsBody: document.getElementById("systems-body"),
        systemsGrid: document.getElementById("systems-grid"),
        interfaceKicker: document.getElementById("interface-kicker"),
        interfaceTitle: document.getElementById("interface-title"),
        interfaceBody: document.getElementById("interface-body"),
        interfaceBadge: document.getElementById("interface-badge"),
        interfaceSource: document.getElementById("interface-source"),
        tabGrid: document.getElementById("tab-grid"),
        languagesKicker: document.getElementById("languages-kicker"),
        languagesTitle: document.getElementById("languages-title"),
        languagesBody: document.getElementById("languages-body"),
        localeGrid: document.getElementById("locale-grid"),
        footerCopy: document.getElementById("footer-copy")
    };

    const metaDescription = document.querySelector('meta[name="description"]');

    function normalizeLocale(input) {
        const raw = String(input || "").toLowerCase();
        const short = raw.split("-")[0];
        if (short === "jp") {
            return "ja";
        }
        return data.locales[short] ? short : "en";
    }

    function getInitialLocale() {
        const stored = normalizeLocale(window.localStorage.getItem("holon-hub-locale"));
        if (stored !== "en" || window.localStorage.getItem("holon-hub-locale")) {
            return stored;
        }
        return normalizeLocale(navigator.language || "en");
    }

    function clearNode(node) {
        while (node.firstChild) {
            node.removeChild(node.firstChild);
        }
    }

    function appendDetailRow(parent, label, value) {
        const wrapper = document.createElement("div");
        const dt = document.createElement("dt");
        const dd = document.createElement("dd");
        dt.textContent = label;
        dd.textContent = value;
        wrapper.append(dt, dd);
        parent.appendChild(wrapper);
    }

    function createTag(text, className) {
        const span = document.createElement("span");
        span.className = className;
        span.textContent = text;
        return span;
    }

    function populateLocaleSelect() {
        clearNode(elements.localeSelect);

        localeKeys.forEach((key) => {
            const locale = data.locales[key];
            const option = document.createElement("option");
            option.value = key;
            option.textContent = `${locale.nativeName} (${locale.label})`;
            elements.localeSelect.appendChild(option);
        });
    }

    function renderStats(locale) {
        clearNode(elements.statsGrid);

        const stats = [
            { value: data.meta.version, label: locale.stats.build },
            { value: String(localeKeys.length), label: locale.stats.languages },
            { value: String(locale.tabs.length), label: locale.stats.tabs },
            { value: data.meta.featureGroups, label: locale.stats.groups }
        ];

        stats.forEach((item) => {
            const card = document.createElement("article");
            card.className = "stat-card";

            const value = document.createElement("span");
            value.className = "stat-value";
            value.textContent = item.value;

            const label = document.createElement("span");
            label.className = "stat-label";
            label.textContent = item.label;

            card.append(value, label);
            elements.statsGrid.appendChild(card);
        });
    }

    function renderSnapshot(locale) {
        clearNode(elements.snapshotList);
        clearNode(elements.sourcePills);

        const rows = [
            {
                label: locale.snapshot.labels.source,
                value: "hub-*.lua + orion.lua"
            },
            {
                label: locale.snapshot.labels.locale,
                value: locale.sourceFile
            },
            {
                label: locale.snapshot.labels.channels,
                value: "Discord / TikTok / YouTube"
            }
        ];

        rows.forEach((row) => appendDetailRow(elements.snapshotList, row.label, row.value));

        data.meta.sourceFiles.forEach((file) => {
            elements.sourcePills.appendChild(createTag(file, "file-pill"));
        });
    }

    function renderOverview(locale) {
        clearNode(elements.detailList);

        const details = [
            [locale.detailLabels.author, data.meta.author],
            [locale.detailLabels.roblox, data.meta.robloxId],
            [locale.detailLabels.foundation, data.meta.uiFoundation],
            [locale.detailLabels.notes, data.meta.notesFolder]
        ];

        details.forEach(([label, value]) => appendDetailRow(elements.detailList, label, value));
    }

    function renderSystems(locale) {
        clearNode(elements.systemsGrid);

        data.meta.systemDefinitions.forEach((system) => {
            const copy = locale.modules[system.key];
            const card = document.createElement("article");
            card.className = "system-card";

            const title = document.createElement("h3");
            title.className = "system-title";
            title.textContent = copy.title;

            const body = document.createElement("p");
            body.className = "system-body";
            body.textContent = copy.text;

            const tagRow = document.createElement("div");
            tagRow.className = "tag-row";
            system.tags.forEach((tag) => {
                tagRow.appendChild(createTag(tag, "tag"));
            });

            card.append(title, body, tagRow);
            elements.systemsGrid.appendChild(card);
        });
    }

    function renderTabs(locale) {
        clearNode(elements.tabGrid);
        elements.interfaceSource.textContent = locale.sourceFile;

        locale.tabs.forEach((tab, index) => {
            const card = document.createElement("article");
            card.className = "tab-card";

            const badge = document.createElement("span");
            badge.className = "tab-index";
            badge.textContent = `${String(index + 1).padStart(2, "0")}`;

            const name = document.createElement("div");
            name.className = "tab-name";
            name.textContent = tab;

            card.append(badge, name);
            elements.tabGrid.appendChild(card);
        });
    }

    function renderLocaleCards(currentLocaleKey, locale) {
        clearNode(elements.localeGrid);

        localeKeys.forEach((key) => {
            const entry = data.locales[key];
            const button = document.createElement("button");
            button.type = "button";
            button.className = "locale-card";
            if (key === currentLocaleKey) {
                button.classList.add("is-active");
            }
            button.setAttribute("aria-pressed", String(key === currentLocaleKey));
            button.addEventListener("click", () => setLocale(key));

            const head = document.createElement("div");
            head.className = "locale-head";

            const name = document.createElement("div");
            name.className = "locale-name";
            name.textContent = entry.nativeName;

            const source = document.createElement("div");
            source.className = "locale-source";
            source.textContent = entry.sourceFile;

            head.append(name, source);

            const tabs = document.createElement("div");
            tabs.className = "locale-tabs";
            entry.tabs.slice(0, 4).forEach((tab) => {
                tabs.appendChild(createTag(tab, "locale-tab-pill"));
            });

            const action = document.createElement("div");
            action.className = "locale-action";
            action.textContent = locale.languages.switchLabel;

            button.append(head, tabs, action);
            elements.localeGrid.appendChild(button);
        });
    }

    function renderNavigation(locale) {
        document.querySelectorAll("[data-nav]").forEach((link) => {
            const key = link.getAttribute("data-nav");
            link.textContent = locale.nav[key];
        });
    }

    function setLocale(localeKey) {
        const key = data.locales[localeKey] ? localeKey : "en";
        const locale = data.locales[key];

        window.localStorage.setItem("holon-hub-locale", key);
        document.documentElement.lang = locale.langTag;
        document.documentElement.dir = locale.dir;
        document.body.dataset.locale = key;

        document.title = `${data.meta.brand} | ${locale.hero.subtitle}`;
        if (metaDescription) {
            metaDescription.setAttribute("content", locale.hero.lead);
        }

        elements.brandVersion.textContent = data.meta.version;
        elements.localeLabel.textContent = locale.localeLabel;
        elements.localeSelect.setAttribute("aria-label", locale.localeLabel);
        elements.localeSelect.value = key;

        renderNavigation(locale);

        elements.heroEyebrow.textContent = locale.hero.eyebrow;
        elements.heroSubtitle.textContent = locale.hero.subtitle;
        elements.heroLead.textContent = locale.hero.lead;

        elements.ctaDiscord.href = data.meta.links.discord;
        elements.ctaTikTok.href = data.meta.links.tiktok;
        elements.ctaYouTube.href = data.meta.links.youtube;
        elements.ctaDiscord.textContent = locale.cta.discord;
        elements.ctaTikTok.textContent = locale.cta.tiktok;
        elements.ctaYouTube.textContent = locale.cta.youtube;

        elements.snapshotKicker.textContent = locale.snapshot.kicker;
        elements.snapshotTitle.textContent = locale.snapshot.title;
        elements.snapshotBody.textContent = locale.snapshot.body;

        elements.overviewKicker.textContent = locale.overview.kicker;
        elements.overviewTitle.textContent = locale.overview.title;
        elements.overviewBody.textContent = locale.overview.body;

        elements.systemsKicker.textContent = locale.systems.kicker;
        elements.systemsTitle.textContent = locale.systems.title;
        elements.systemsBody.textContent = locale.systems.body;

        elements.interfaceKicker.textContent = locale.interface.kicker;
        elements.interfaceTitle.textContent = locale.interface.title;
        elements.interfaceBody.textContent = locale.interface.body;
        elements.interfaceBadge.textContent = locale.interface.badge;

        elements.languagesKicker.textContent = locale.languages.kicker;
        elements.languagesTitle.textContent = locale.languages.title;
        elements.languagesBody.textContent = locale.languages.body;

        elements.footerCopy.textContent = locale.footer;

        renderStats(locale);
        renderSnapshot(locale);
        renderOverview(locale);
        renderSystems(locale);
        renderTabs(locale);
        renderLocaleCards(key, locale);
    }

    function setupReveal() {
        const revealNodes = document.querySelectorAll(".reveal");
        if (!("IntersectionObserver" in window)) {
            revealNodes.forEach((node) => node.classList.add("is-visible"));
            return;
        }

        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("is-visible");
                        observer.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.14
            }
        );

        revealNodes.forEach((node) => observer.observe(node));
    }

    populateLocaleSelect();
    setupReveal();

    elements.localeSelect.addEventListener("change", (event) => {
        setLocale(event.target.value);
    });

    setLocale(getInitialLocale());
})();
