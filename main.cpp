#include "spdlog/logger.h"
#include "spdlog/spdlog.h"
#include "spdlog/sinks/stdout_color_sinks.h"

#define LOGGER_NAME "test"

static inline std::shared_ptr<spdlog::logger> get_logger() {
    auto logger = spdlog::get(LOGGER_NAME);
    if (!logger) {
        auto sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
        logger = std::make_shared<spdlog::logger>(LOGGER_NAME, sink);
        logger->set_pattern("%^[%H:%M:%S] [%n] [Thread:%t] [%L] %v%$");
        logger->set_level(spdlog::level::debug);
        spdlog::register_logger(logger);
    }
    return logger;
}

#define LOGD(fmt, ...) get_logger()->debug(fmt, ##__VA_ARGS__)
#define LOGI(fmt, ...) get_logger()->info(fmt, ##__VA_ARGS__)
#define LOGW(fmt, ...) get_logger()->warn(fmt, ##__VA_ARGS__)
#define LOGE(fmt, ...) get_logger()->error(fmt, ##__VA_ARGS__)

int main() {
    LOGI("Hello {}", "world");
    return 0;
}
