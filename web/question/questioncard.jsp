<c:forEach items="${questionList}" var="q">

    <div class="question-card">

        <h3>${q.content}</h3>

        <c:choose>

            <!-- Multiple Choice -->
            <c:when test="${q.questionType == 'MCQ'}">

                <c:forEach items="${q.options}" var="o">

                    <label>
                        <input type="radio"
                               name="q${q.questionId}"
                               value="${o.optionId}">

                        ${o.optionLabel}. ${o.optionContent}
                    </label>
                    <br>

                </c:forEach>

            </c:when>

            <!-- True False -->
            <c:when test="${q.questionType == 'TrueFalse'}">

                <c:forEach items="${q.options}" var="o">

                    <label>
                        <input type="radio"
                               name="q${q.questionId}"
                               value="${o.optionId}">

                        ${o.optionContent}
                    </label>
                    <br>

                </c:forEach>

            </c:when>

            <!-- Essay -->
            <c:otherwise>

                <textarea name="q${q.questionId}"
                          rows="5"
                          cols="60"></textarea>

            </c:otherwise>

        </c:choose>

    </div>

</c:forEach>